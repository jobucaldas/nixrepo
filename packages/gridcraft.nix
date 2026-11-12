{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "gridcraft";
  version = "0.19.1";

  url = "https://github.com/storytold/gridcraft/releases/download/v${version}/gridcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-WxzhCtbHotOJJJ39JZAQAUqF/OGqQsYn/EzaVxZx4iE=";

  desktopFile = "ai.storyteller.gridcraft.desktop";

  installCli = true;

  passthru.updateInfo = {
    repo = "storytold/gridcraft";
    assetRegex = "^gridcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/gridcraft.nix";
  };

  meta = {
    description = "Open-source spreadsheet and data analysis application written in pure Rust";
    homepage = "https://getartcraft.com/apps/gridcraft";
    license = lib.licenses.asl20;
  };
}
