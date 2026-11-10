{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "pdfcraft";
  version = "0.20.0";

  url = "https://github.com/storytold/pdfcraft/releases/download/v${version}/pdfcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-An5iKZuCNTYANz5sp0xEEhPvVAbnDSf38a734Fp4h40=";

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
