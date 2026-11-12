{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "photocraft";
  version = "0.23.1";

  url = "https://github.com/storytold/photocraft/releases/download/v${version}/photocraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-BXR7PlJ+HgoMHeOZcDYc84yPyn6NPjYB7yCC+w5t0X8=";

  desktopFile = "ai.storyteller.photocraft.desktop";

  installCli = true;

  passthru.updateInfo = {
    repo = "storytold/photocraft";
    assetRegex = "^photocraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/photocraft.nix";
  };

  meta = {
    description = "Open-source photo editor written from scratch in pure Rust";
    homepage = "https://getartcraft.com/apps/photocraft";
    license = lib.licenses.asl20;
  };
}
