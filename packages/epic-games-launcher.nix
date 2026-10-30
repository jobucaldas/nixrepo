{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "epic-games-launcher";
  version = "0.106.0+g0cb1183";

  url = "https://content-download-egs.distro.on.epicgames.com/Builds/EGLv2/${
    lib.replaceStrings [ "+" ] [ "%2B" ] version
  }/Linux/EpicGamesLauncher-x86_64.AppImage";
  hash = "sha256-QVwiWRVC6+ZOLoji5wXO5XabobLI1TTezuYu75jRwkg=";

  extraInstallCommands = _: ''
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail "Exec=EpicGamesLauncher" "Exec=${pname}"
  '';

  passthru.updateInfo = {
    type = "redirect";
    url = "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncher-x86_64.AppImage";
    versionRegex = "/EGLv2/(?<version>[^/]+)/Linux/";
    sourceFile = "packages/epic-games-launcher.nix";
  };

  meta = {
    description = "Epic Games Launcher for Linux";
    homepage = "https://store.epicgames.com/";
    license = lib.licenses.unfree;
  };
}
