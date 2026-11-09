{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "soundcraft";
  version = "0.19.0";

  url = "https://github.com/storytold/soundcraft/releases/download/v${version}/soundcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-qt7XTk8TLAM6zBIjx3anTlmnUdyQiEG0wxVy44k5GY8=";

  desktopFile = "ai.storyteller.soundcraft.desktop";

  passthru.updateInfo = {
    repo = "storytold/soundcraft";
    assetRegex = "^soundcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/soundcraft.nix";
  };

  meta = {
    description = "Open-source digital audio workstation written from scratch in pure Rust";
    homepage = "https://getartcraft.com/apps/soundcraft";
    license = lib.licenses.asl20;
  };
}
