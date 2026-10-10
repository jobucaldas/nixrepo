{
  fetchurl,
  lib,
  python3,
  stdenvNoCC,
  unzip,
}:

{
  installDir,
  pluginName,
  version,
  archiveHash,
  hash,
}:

stdenvNoCC.mkDerivation {
  pname = "decky-plugin-${lib.strings.sanitizeDerivationName installDir}";
  inherit version;

  src = fetchurl {
    url = "https://cdn.tzatzikiweeb.moe/file/steam-deck-homebrew/versions/${archiveHash}.zip";
    inherit hash;
  };

  dontUnpack = true;
  nativeBuildInputs = [
    python3
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir unpacked
    unzip -q "$src" -d unpacked
    bundle="unpacked/${installDir}"
    test -f "$bundle/plugin.json"
    test -f "$bundle/package.json"

    python3 - "$bundle" "${pluginName}" "${version}" <<'PY'
    import json
    import pathlib
    import sys

    bundle = pathlib.Path(sys.argv[1])
    plugin = json.loads((bundle / "plugin.json").read_text())
    package = json.loads((bundle / "package.json").read_text())
    if plugin.get("name") != sys.argv[2]:
        raise SystemExit(f"plugin.json name mismatch: {plugin.get('name')!r}")
    if package.get("version") != sys.argv[3]:
        raise SystemExit(f"package.json version mismatch: {package.get('version')!r}")
    if not (bundle / "dist" / "index.js").is_file():
        raise SystemExit("plugin bundle is missing dist/index.js")
    PY

    mkdir -p "$out"
    cp -a "$bundle"/. "$out"/

    runHook postInstall
  '';

  passthru = {
    inherit installDir pluginName;
    pluginVersion = version;
  };

  meta = {
    description = "Pinned Decky plugin bundle: ${pluginName}";
    homepage = "https://plugins.deckbrew.xyz/";
    platforms = lib.platforms.linux;
  };
}
