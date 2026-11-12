{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "effectcraft";
  version = "0.24.1";

  url = "https://github.com/storytold/effectcraft/releases/download/v${version}/effectcraft-${version}-linux-x86_64.AppImage";
  hash = "sha256-n4oWz3QUfJ4qw7ZfpvW+lqPhDq2S3fCNVE9dOZCtZNw=";

  desktopFile = "ai.storyteller.effectcraft.desktop";

  installCli = true;

  passthru.updateInfo = {
    repo = "storytold/effectcraft";
    assetRegex = "^effectcraft-.*-linux-x86_64\\.AppImage$";
    sourceFile = "packages/effectcraft.nix";
  };

  meta = {
    description = "Open-source motion graphics and compositing tool built in pure Rust";
    homepage = "https://getartcraft.com/apps/effectcraft";
    license = lib.licenses.asl20;
  };
}
