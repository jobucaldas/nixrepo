{
  appimageTools,
  desktop-file-utils,
  fetchurl,
  lib,
}:
{
  pname,
  version,
  url,
  hash,
  desktopFile ? "${pname}.desktop",
  desktopExec ? pname,
  installDesktopFile ? true,
  installIcons ? true,
  extraPkgs ? pkgs: [ ],
  extraInstallCommands ? "",
  passthru ? { },
  meta ? { },
}:
let
  src = fetchurl {
    inherit url hash;
  };

  contents = appimageTools.extract {
    inherit pname version src;
  };

  additionalInstallCommands =
    if builtins.isFunction extraInstallCommands then
      extraInstallCommands contents
    else
      extraInstallCommands;
in
appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    extraPkgs
    ;

  extraInstallCommands =
    lib.optionalString installDesktopFile ''
      install -m 444 -D ${contents}/${desktopFile} \
        $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-warn "Exec=AppRun" "Exec=${desktopExec}"
    ''
    + lib.optionalString installIcons ''
      if [ -d ${contents}/usr/share/icons ]; then
        mkdir -p $out/share
        cp -r ${contents}/usr/share/icons $out/share/
        chmod -R u+w $out/share/icons
      fi
    ''
    + additionalInstallCommands
    + lib.optionalString installDesktopFile ''
      ${desktop-file-utils}/bin/desktop-file-validate \
        $out/share/applications/${pname}.desktop
    '';

  inherit passthru;

  meta = {
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  }
  // meta;
}
