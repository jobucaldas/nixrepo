{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "materialcraft";
  version = "0.4.1";

  url = "https://github.com/storytold/materialcraft/releases/download/v${version}/materialcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-1R++QDSoIgR0UHIi9k2AHiZknIEzs+e0WPPpdYwItqE=";

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
