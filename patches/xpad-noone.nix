{ lib, kernel }:
old: {
  # Kbuild's installer generates the deterministic signature and .ko.cer
  # required by nixpkgs' module aggregator. Remove when fixed upstream.
  installPhase = ''
    runHook preInstall

    make ${lib.escapeShellArgs old.makeFlags} \
      -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M="$PWD" INSTALL_MOD_PATH="$out" \
      INSTALL_MOD_DIR=kernel/drivers/xpad-noone modules_install

    runHook postInstall
  '';
}
