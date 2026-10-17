{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "vacuumtube";
  version = "2.0.1";

  url = "https://github.com/shy1132/VacuumTube/releases/download/v${version}/VacuumTube-x86_64.AppImage";
  hash = "sha256-go1v5Hsa3Lgpj4GqfhoLQoQaztvFELXAJg0xD/maQmQ=";

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
