{
  lib,
  mkAppImage,
}:
let
  version = "1.0.3+wispr1.6.7";
  parts = builtins.match "([^+]+)\\+wispr(.+)" version;
  portVersion = builtins.elemAt parts 0;
  appVersion = builtins.elemAt parts 1;
in
mkAppImage {
  pname = "wispr-flow";
  inherit version;

  url = "https://github.com/wispr-flow-linux/wispr-flow-linux/releases/download/v${version}/wispr-flow-${appVersion}-${portVersion}-x86_64.AppImage";
  hash = "sha256-T9/evAykYnc20TVc7sX3Bwf8aTkTkxEtDr8FNavIMfA=";

  desktopFile = "ai.wisprflow.WisprFlow.desktop";
  desktopExec = "wispr-flow";

  extraInstallCommands = contents: ''
    install -Dm444 ${contents}/ai.wisprflow.WisprFlow.png \
      $out/share/icons/hicolor/256x256/apps/ai.wisprflow.WisprFlow.png
  '';

  passthru.updateInfo = {
    repo = "wispr-flow-linux/wispr-flow-linux";
    assetRegex = "^wispr-flow-.*-x86_64\\.AppImage$";
    sourceFile = "packages/wispr-flow.nix";
  };

  meta = {
    description = "Voice dictation that types into your focused app (unofficial Linux port of Wispr Flow)";
    homepage = "https://wisprflow.ai";
    license = lib.licenses.unfree;
  };
}
