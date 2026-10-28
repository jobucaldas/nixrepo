{ lib, mkAppImage }:
let
  version = "0.52.1";
in
mkAppImage {
  pname = "openbot";
  inherit version;
  url = "https://github.com/nightly-labs/openbot/releases/download/v${version}/OpenBot-${version}-x86_64.AppImage";
  hash = "sha256-ZyBOA9EqfA+j46Bzfq1Hy5i50zuTM/+tCkWO2BPDnfA=";

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
