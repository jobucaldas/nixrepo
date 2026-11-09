{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "cadcraft";
  version = "0.19.0";

  url = "https://github.com/storytold/cadcraft/releases/download/v${version}/cadcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-AZ0KSroVUPr5FiTo0686344n/uGZdXm1T5hfaTOVuvk=";

  desktopFile = "ai.storyteller.cadcraft.desktop";

  passthru.updateInfo = {
    repo = "storytold/cadcraft";
    assetRegex = "^cadcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/cadcraft.nix";
  };

  meta = {
    description = "Open-source computer-aided design and drafting application written in pure Rust";
    homepage = "https://getartcraft.com/apps/cadcraft";
    license = lib.licenses.asl20;
  };
}
