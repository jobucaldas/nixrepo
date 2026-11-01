{ lib, mkAppImage }:
let
  version = "0.57.0";
in
mkAppImage {
  pname = "openbot";
  inherit version;
  url = "https://github.com/nightly-labs/openbot/releases/download/v${version}/OpenBot-${version}-x86_64.AppImage";
  hash = "sha256-utftEySHVsZ1nRRI+3gd2u/6e8tUihqnKYsqVRvcsp8=";

  passthru.updateInfo = {
    repo = "nightly-labs/openbot";
    assetRegex = "^OpenBot-.*-x86_64\\.AppImage$";
    sourceFile = "packages/openbot.nix";
  };

  meta = {
    description = "Local-first desktop workspace for AI agents";
    homepage = "https://openbot.run";
    license = lib.licenses.unfree;
  };
}
