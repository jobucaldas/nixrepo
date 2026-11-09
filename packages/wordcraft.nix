{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "wordcraft";
  version = "0.17.0";

  url = "https://github.com/storytold/wordcraft/releases/download/v${version}/wordcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-YGs64zDHZ8+hkoA9uo63udKcZs3ynQyr3gg/F/Bq0Ws=";

  desktopFile = "ai.storyteller.wordcraft.desktop";

  passthru.updateInfo = {
    repo = "storytold/wordcraft";
    assetRegex = "^wordcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/wordcraft.nix";
  };

  meta = {
    description = "Open-source word processor written from scratch in pure Rust";
    homepage = "https://getartcraft.com/apps/wordcraft";
    license = lib.licenses.asl20;
  };
}
