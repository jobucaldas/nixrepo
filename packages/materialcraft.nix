{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "materialcraft";
  version = "0.3.0";

  url = "https://github.com/storytold/materialcraft/releases/download/v${version}/materialcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-rKIn8H0AR7xi3tj83mPdzDwQUZYPWTwCkZTW6d1Kaz0=";

  desktopFile = "ai.storyteller.materialcraft.desktop";

  installCli = true;

  passthru.updateInfo = {
    repo = "storytold/materialcraft";
    assetRegex = "^materialcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/materialcraft.nix";
  };

  meta = {
    description = "Open-source node-based material designer written from scratch in pure Rust";
    homepage = "https://getartcraft.com/apps/materialcraft";
    license = lib.licenses.asl20;
  };
}
