{
  lib,
  mkAppImage,
  runtimeShell,
}:
mkAppImage rec {
  pname = "xodus-nexus";
  version = "0.3.11";

  url = "https://github.com/domsvoboda/xodus-nexus/releases/download/v${version}/Xodus-Nexus-${version}-x86_64.AppImage";
  hash = "sha256-r1hpK/5dFTDui8/o7hIGCKLqcZ5FzZN4jk4m9MudvgM=";

  # The managed Wine runtime also needs the 32-bit Linux loader and libraries.
  multiArch = true;

  extraPkgs =
    pkgs: with pkgs; [
      # The downloaded backend uses WebKitGTK for Microsoft account sign-in.
      webkitgtk_4_1
      # Wine loads GnuTLS dynamically for Xbox sign-in and cryptographic operations.
      gnutls
      # The managed runtime's GStreamer video and audio plugins need these.
      libgudev
      libopus
      # Nexus imports into a running client via /usr/bin/steam inside this FHS.
      # Forward to the host's Nix wrapper without bundling another Steam client.
      (writeShellScriptBin "steam" ''
        for launcher in /run/current-system/sw/bin/steam \
          "/etc/profiles/per-user/$USER/bin/steam" "$HOME/.nix-profile/bin/steam"; do
          if [ -x "$launcher" ]; then
            exec "$launcher" "$@"
          fi
        done
        echo "Steam is not installed in a Nix profile." >&2
        exit 127
      '')
    ];

  # Electron needs the persistent entry point for Steam/desktop shortcuts.
  # The extracted binary bypasses the FHS environment, so advertise this wrapper.
  # Its non-.AppImage path also keeps updates managed by Nix.
  extraInstallCommands = ''
    launcher="$out/bin/xodus-nexus"
    target="$(readlink -f "$launcher")"
    rm "$launcher"
    cat > "$launcher" <<EOF
    #!${runtimeShell}
    export APPIMAGE="$launcher"
    # Keep Electron's secrets out of the login keyring, which may be locked
    # when the session starts (for example under gamescope autologin).
    exec "$target" --no-sandbox --password-store=basic "\$@"
    EOF
    chmod 0555 "$launcher"
  '';

  passthru.updateInfo = {
    repo = "domsvoboda/xodus-nexus";
    assetRegex = "^Xodus-Nexus-.*-x86_64\\.AppImage$";
    sourceFile = "packages/xodus-nexus.nix";
  };

  meta = {
    description = "Xbox-inspired Microsoft Store game launcher for Linux";
    homepage = "https://github.com/domsvoboda/xodus-nexus";
    license = lib.licenses.mit;
  };
}
