{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "figcraft";
  version = "0.17.0";

  url = "https://github.com/storytold/figcraft/releases/download/v${version}/figcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-p0nZ+AdMvS3H0EoW1HJiABolKDkfoVO9bFxOT4TI5BQ=";

  desktopFile = "ai.storyteller.figcraft.desktop";

  installCli = true;

  passthru.updateInfo = {
    repo = "storytold/figcraft";
    assetRegex = "^figcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/figcraft.nix";
  };

  meta = {
    description = "Open-source interface design and prototyping tool written from scratch in pure Rust";
    homepage = "https://getartcraft.com/apps/figcraft";
    license = lib.licenses.asl20;
  };
}
