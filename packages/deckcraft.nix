{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "deckcraft";
  version = "0.18.1";

  url = "https://github.com/storytold/deckcraft/releases/download/v${version}/deckcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-aN+fBA0/bEzkqQSq3sYzlh+hmSSPChqjZvpkWXrgmGc=";

  desktopFile = "ai.storyteller.deckcraft.desktop";

  installCli = true;

  passthru.updateInfo = {
    repo = "storytold/deckcraft";
    assetRegex = "^deckcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/deckcraft.nix";
  };

  meta = {
    description = "Open-source presentation and slide show editor written from scratch in pure Rust";
    homepage = "https://getartcraft.com/apps/deckcraft";
    license = lib.licenses.asl20;
  };
}
