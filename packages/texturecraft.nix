{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "texturecraft";
  version = "0.5.0";

  url = "https://github.com/storytold/texturecraft/releases/download/v${version}/texturecraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-so8Kf2ldQfWAn6UbhYjXG5k388X1hi7GEJB9CW7lzQA=";

  desktopFile = "ai.storyteller.texturecraft.desktop";

  passthru.updateInfo = {
    repo = "storytold/texturecraft";
    assetRegex = "^texturecraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/texturecraft.nix";
  };

  meta = {
    description = "Open-source 3D texture painting workflow written from scratch in pure Rust";
    homepage = "https://getartcraft.com/apps/texturecraft";
    license = lib.licenses.asl20;
  };
}
