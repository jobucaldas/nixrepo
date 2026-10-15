{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "vacuumtube";
  version = "2.0.0";

  url = "https://github.com/shy1132/VacuumTube/releases/download/v${version}/VacuumTube-x86_64.AppImage";
  hash = "sha256-0/IreFZQWw9feMSMPPSVvCYZagsPpJZzsfFz8BJW/SA=";

  # Since 2.0.0 the desktop file uses the application ID; the icon is now
  # installed in usr/share/icons and copied by mkAppImage.
  desktopFile = "rocks.shy.VacuumTube.desktop";

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
