{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "filmcraft";
  version = "0.20.1";

  url = "https://github.com/storytold/filmcraft/releases/download/v${version}/filmcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-SiWuyy6UgbZec1NSi8qeSoxTiN1V8Uhv/mRQLgi9+gI=";

  desktopFile = "ai.storyteller.filmcraft.desktop";

  installCli = true;

  passthru.updateInfo = {
    repo = "storytold/filmcraft";
    assetRegex = "^filmcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/filmcraft.nix";
  };

  meta = {
    description = "Open-source nonlinear video editor written from scratch in pure Rust";
    homepage = "https://getartcraft.com/apps/filmcraft";
    license = lib.licenses.asl20;
  };
}
