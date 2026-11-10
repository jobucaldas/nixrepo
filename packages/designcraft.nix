{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "designcraft";
  version = "0.19.0";

  url = "https://github.com/storytold/designcraft/releases/download/v${version}/designcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-6CINfkF3kOFSjchNTbX7IpPdAyfmLuKfjKA/CSgB6aU=";

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
