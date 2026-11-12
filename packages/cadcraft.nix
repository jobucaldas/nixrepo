{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "cadcraft";
  version = "0.20.1";

  url = "https://github.com/storytold/cadcraft/releases/download/v${version}/cadcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-56XSRFAP5FzKv6hcYywl7NofsDeZwxjZrVQfZbFQ548=";

  desktopFile = "ai.storyteller.cadcraft.desktop";

  installCli = true;

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
