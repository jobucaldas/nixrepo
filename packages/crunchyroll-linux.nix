{
  lib,
  mkAppImage,
}:
mkAppImage rec {
  pname = "crunchyroll-linux";
  version = "1.1.6";

  url = "https://github.com/aarron-lee/crunchyroll-linux/releases/download/v${version}/Crunchyroll_v${version}_linux.AppImage";
  hash = "sha256-ugZnD7Icjlr6HUJBpL+RH9v9m0e8HtTUSebQVkXMzfo=";

  extraInstallCommands = _: ''
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-warn "Categories=Video;" "Categories=AudioVideo;Video;"
  '';

  passthru.updateInfo = {
    repo = "aarron-lee/crunchyroll-linux";
    assetRegex = "^Crunchyroll_v[0-9.]+_linux\\.AppImage$";
    sourceFile = "packages/crunchyroll-linux.nix";
  };

  meta = {
    description = "Unofficial Crunchyroll TV and HTPC application for Linux";
    homepage = "https://github.com/aarron-lee/crunchyroll-linux";
    license = lib.licenses.asl20;
  };
}
