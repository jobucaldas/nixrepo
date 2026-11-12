{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "designcraft";
  version = "0.20.1";

  url = "https://github.com/storytold/designcraft/releases/download/v${version}/designcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-+db9a7GkIYUCQ8DUvkQjVxOp7Fsm+L8dW6h6/Pj5FTQ=";

  desktopFile = "ai.storyteller.designcraft.desktop";

  installCli = true;

  passthru.updateInfo = {
    repo = "storytold/designcraft";
    assetRegex = "^designcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/designcraft.nix";
  };

  meta = {
    description = "Open-source page layout and publishing editor written from scratch in pure Rust";
    homepage = "https://getartcraft.com/apps/designcraft";
    license = lib.licenses.asl20;
  };
}
