{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "craft-anything";
  version = "0.6.0";

  url = "https://github.com/storytold/craft-anything/releases/download/v${version}/craft-anything-${version}-linux-x86_64.AppImage";
  hash = "sha256-mswr764Dgd7p3OvSVbzcdZKxafTvR3nC4tQj8Xz2vzk=";

  desktopFile = "ai.storyteller.craft-anything.desktop";

  installCli = true;

  passthru.updateInfo = {
    repo = "storytold/craft-anything";
    assetRegex = "^craft-anything-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/craft-anything.nix";
  };

  meta = {
    description = "Explore how software works and build your own version";
    homepage = "https://getartcraft.com/apps/craft-anything";
    license = lib.licenses.asl20;
  };
}
