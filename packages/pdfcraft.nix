{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "pdfcraft";
  version = "0.21.1";

  url = "https://github.com/storytold/pdfcraft/releases/download/v${version}/pdfcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-cwJ2zamt2z1I8mxgJobRj8W8Dr42CmCi9SLXDP1CjSE=";

  desktopFile = "ai.storyteller.pdfcraft.desktop";

  installCli = true;

  passthru.updateInfo = {
    repo = "storytold/pdfcraft";
    assetRegex = "^pdfcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/pdfcraft.nix";
  };

  meta = {
    description = "Open-source PDF workbench to read, organize, combine, split and secure documents";
    homepage = "https://getartcraft.com/apps/pdfcraft";
    license = lib.licenses.asl20;
  };
}
