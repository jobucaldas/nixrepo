{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "vectorcraft";
  version = "0.23.0";

  url = "https://github.com/storytold/vectorcraft/releases/download/v${version}/vectorcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-ihMPRI+o3/CiedzvylYin1cCyzQRIyY0NtWHxFviqOQ=";

  desktopFile = "ai.storyteller.vectorcraft.desktop";

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
