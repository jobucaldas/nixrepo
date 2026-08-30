{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "helium";
  version = "0.16.2.1";

  url = "https://github.com/imputnet/helium-linux/releases/download/${version}/${pname}-${version}-x86_64.AppImage";
  hash = "sha256-LS3sjyzR1ySfD0L9RulF5Zgys9FDLm8APYR/AJcKDQI=";

  passthru.updateInfo = {
    repo = "imputnet/helium-linux";
    assetRegex = "^helium-[0-9.]+-x86_64\\.AppImage$";
    sourceFile = "packages/helium.nix";
  };

  meta = {
    description = "Private, fast, and user-friendly Chromium-based web browser";
    homepage = "https://github.com/imputnet/helium";
    license = lib.licenses.gpl3Only;
  };
}
