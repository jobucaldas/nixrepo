{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "vacuumtube";
  version = "1.8.2";

  url = "https://github.com/shy1132/VacuumTube/releases/download/v${version}/VacuumTube-x86_64.AppImage";
  hash = "sha256-KWNe6Rq2fmEHP6hvpF67alzpUH/rc6kZfCbL5ZYh038=";

  # The upstream AppImage places its scalable icon outside the standard apps
  # subdirectory, so install a discoverable copy as well.
  extraInstallCommands = contents: ''
    install -Dm444 ${contents}/vacuumtube.svg \
      $out/share/icons/hicolor/scalable/apps/vacuumtube.svg
  '';

  passthru.updateInfo = {
    repo = "shy1132/VacuumTube";
    assetRegex = "^VacuumTube-x86_64\\.AppImage$";
    sourceFile = "packages/vacuumtube.nix";
  };

  meta = {
    description = "YouTube Leanback client for the desktop";
    homepage = "https://github.com/shy1132/VacuumTube";
    license = lib.licenses.mit;
  };
}
