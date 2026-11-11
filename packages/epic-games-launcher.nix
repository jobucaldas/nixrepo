{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  buildFHSEnv,
  glib-networking,
  writeShellScript,
  webkitgtk_4_1,
  gtk3,
  libsoup_3,
  libayatana-appindicator,
}:
let
  pname = "epic-games-launcher";
  version = "0.114.0+g04485d6";
  hash = "sha256-C9Pj7CdsGvXIZwMlxXtwKSkPtIEd4Hhb/jYqMWE/lsc=";

  src = fetchurl {
    url = "https://content-download-egs.distro.on.epicgames.com/Builds/EGLv2/${
      lib.replaceStrings [ "+" ] [ "%2B" ] version
    }/Linux/EpicGamesLauncher-x86_64.deb";
    inherit hash;
  };

  # The launcher ships as a Debian package; unpack it so the binary keeps the
  # $ORIGIN/../lib/epic-games-launcher RUNPATH it was built with.
  unpacked = stdenvNoCC.mkDerivation {
    pname = "${pname}-unpacked";
    inherit version src;

    nativeBuildInputs = [ dpkg ];

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb --extract $src .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r usr/. $out/
      runHook postInstall
    '';

    dontPatchELF = true;
    dontStrip = true;
  };
in
buildFHSEnv {
  inherit pname version;

  targetPkgs =
    pkgs: with pkgs; [
      webkitgtk_4_1
      gtk3
      libsoup_3
      libayatana-appindicator
      glib
      glib-networking # TLS for the WebKitGTK social panel
      gdk-pixbuf
      cairo
      pango
      atk
      harfbuzz
      fontconfig
      freetype
      dbus
      alsa-lib
      cups
      expat
      libdrm
      libgbm
      libxkbcommon
      mesa
      nss
      nspr
      libx11
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxrender
      libxi
      libxcb
      xdg-utils
      zenity
    ];

  runScript = writeShellScript "${pname}-run" ''
    export GIO_EXTRA_MODULES=${lib.makeSearchPath "lib/gio/modules" [ glib-networking ]}
    exec ${unpacked}/bin/EpicGamesLauncher "$@"
  '';

  extraInstallCommands = ''
    install -Dm444 ${unpacked}/share/applications/${pname}.desktop \
      $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail "Exec=EpicGamesLauncher" "Exec=${pname}"
    mkdir -p $out/share
    cp -r ${unpacked}/share/icons $out/share/
    chmod -R u+w $out/share/icons
  '';

  passthru.updateInfo = {
    type = "redirect";
    url = "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncher-x86_64.deb";
    versionRegex = "/EGLv2/(?<version>[^/]+)/Linux/";
    sourceFile = "packages/epic-games-launcher.nix";
  };

  meta = {
    description = "Epic Games Launcher for Linux";
    homepage = "https://store.epicgames.com/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
