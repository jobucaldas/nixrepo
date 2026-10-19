{
  lib,
  makeWrapper,
  mkAppImage,
}:
mkAppImage rec {
  pname = "prime-wine";
  version = "0.1.0";

  url = "https://github.com/NelloKudo/prime-wine/releases/download/v${version}/PrimeWine-x86_64.AppImage";
  hash = "sha256-qsXGAtNURucioWPAiVzOV2zhA1oNJi4aqWf4muRy3+g=";

  extraPkgs =
    pkgs: with pkgs; [
      gnutar
      xz
      cabextract
      wget
      unzip
    ];

  extraInstallCommands = contents: ''
    install -Dm444 ${contents}/prime-wine.png \
      $out/share/icons/hicolor/256x256/apps/prime-wine.png

    # Generated user desktop entries must launch the FHS wrapper, including
    # after package upgrades, rather than the extracted executable.
    source ${makeWrapper}/nix-support/setup-hook
    wrapProgram $out/bin/${pname} \
      --set APPIMAGE ${pname}
  '';

  passthru.updateInfo = {
    repo = "NelloKudo/prime-wine";
    assetRegex = "^PrimeWine-x86_64\\.AppImage$";
    sourceFile = "packages/prime-wine.nix";
  };

  meta = {
    description = "Prime Video client using Wine and Brave for HD playback";
    homepage = "https://github.com/NelloKudo/prime-wine";
    license = lib.licenses.agpl3Only;
  };
}
