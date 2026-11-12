{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "vectorcraft";
  version = "0.24.1";

  url = "https://github.com/storytold/vectorcraft/releases/download/v${version}/vectorcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-vc5+gumB+fTtC/JfpvJeb+T6sn6JZB5vlIiZ4BsTpRQ=";

  desktopFile = "ai.storyteller.vectorcraft.desktop";

  installCli = true;

  passthru.updateInfo = {
    repo = "storytold/vectorcraft";
    assetRegex = "^vectorcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/vectorcraft.nix";
  };

  meta = {
    description = "Open-source vector illustration tool written from scratch in pure Rust";
    homepage = "https://getartcraft.com/apps/vectorcraft";
    license = lib.licenses.asl20;
  };
}
