{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "lightcraft";
  version = "0.20.0";

  url = "https://github.com/storytold/lightcraft/releases/download/v${version}/lightcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-Zr4ekYXVb2AIbpp8AZBk3SONlVMcE8DhyDpSf863PhA=";

  desktopFile = "ai.storyteller.lightcraft.desktop";

  installCli = true;

  passthru.updateInfo = {
    repo = "storytold/lightcraft";
    assetRegex = "^lightcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/lightcraft.nix";
  };

  meta = {
    description = "Open-source photo library and raw developer written from scratch in pure Rust";
    homepage = "https://getartcraft.com/apps/lightcraft";
    license = lib.licenses.asl20;
  };
}
