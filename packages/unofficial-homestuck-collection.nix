{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "unofficial-homestuck-collection";
  version = "2.8.1";

  url = "https://github.com/GiovanH/unofficial-homestuck-collection/releases/download/v${version}/The-Unofficial-Homestuck-Collection-${version}.AppImage";
  hash = "sha256-xyVHLmSha4fRsLl8lm97oThlf54/Bg/jMMx3wm+2xOI=";

  extraInstallCommands = _: ''
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-warn "Categories=game;" "Categories=Game;"
  '';

  passthru.updateInfo = {
    repo = "GiovanH/unofficial-homestuck-collection";
    assetRegex = "^The-Unofficial-Homestuck-Collection-[0-9.]+\\.AppImage$";
    sourceFile = "packages/unofficial-homestuck-collection.nix";
  };

  meta = {
    description = "Offline collection of Homestuck and its related works";
    homepage = "https://github.com/GiovanH/unofficial-homestuck-collection";
    license = lib.licenses.gpl3Only;
  };
}
