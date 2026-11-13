{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "openmausbot";
  version = "0.1.155";

  url = "https://github.com/milind-soni/OpenMausBot/releases/download/v${version}/OpenMausBot-${version}-x86_64.AppImage";
  hash = "sha256-f45ot/lY+5ExwsYJNeoqfZPiwAvdlukdXhcGkWyRzEE=";

  desktopFile = "com.openmausbot.app.desktop";

  passthru.updateInfo = {
    repo = "milind-soni/OpenMausBot";
    assetRegex = "^OpenMausBot-.*-x86_64\\.AppImage$";
    sourceFile = "packages/openmausbot.nix";
  };

  meta = {
    description = "Open-source bot platform with a virtual machine bots can use";
    homepage = "https://github.com/milind-soni/OpenMausBot";
    license = lib.licenses.asl20;
  };
}
