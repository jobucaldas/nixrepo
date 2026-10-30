{ lib, mkAppImage }:
let
  version = "0.54.0";
in
mkAppImage {
  pname = "openbot";
  inherit version;
  url = "https://github.com/nightly-labs/openbot/releases/download/v${version}/OpenBot-${version}-x86_64.AppImage";
  hash = "sha256-ikIY9UNjCU4Ga6IRA6OEsK88JwsOq1mi5kXnfC+1nYA=";

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
