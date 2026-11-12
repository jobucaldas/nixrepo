{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "texturecraft";
  version = "0.6.1";

  url = "https://github.com/storytold/texturecraft/releases/download/v${version}/texturecraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-kEdgAW/TdL8J/RtKPIQBy8fmvDy8DUQn43S5v4ExbKY=";

  desktopFile = "ai.storyteller.texturecraft.desktop";

  installCli = true;

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
