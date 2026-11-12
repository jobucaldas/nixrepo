{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "soundcraft";
  version = "0.20.1";

  url = "https://github.com/storytold/soundcraft/releases/download/v${version}/soundcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-TbtAKkE+wqUxA7n6d9Y1bm/usIbZSXXJXmNcdLQ02vg=";

  desktopFile = "ai.storyteller.soundcraft.desktop";

  installCli = true;

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
