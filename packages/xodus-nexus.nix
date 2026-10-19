{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "xodus-nexus";
  version = "0.3.8";

  url = "https://github.com/domsvoboda/xodus-nexus/releases/download/v${version}/Xodus-Nexus-${version}-x86_64.AppImage";
  hash = "sha256-0zo6NrGv8A2HL2jOPIRWNHsnLLlPIMRPr4SMVyWnw6M=";

  # The downloaded backend uses WebKitGTK for Microsoft account sign-in.
  extraPkgs = pkgs: with pkgs; [ webkitgtk_4_1 ];

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
