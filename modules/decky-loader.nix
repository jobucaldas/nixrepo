{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nixrepo.decky-loader;
  stateDir = if cfg.stateDir != null then cfg.stateDir else config.jovian.decky-loader.stateDir;
  loaderSettings = "${stateDir}/settings/loader.json";
  hasEnabledJovianDecky = (options.jovian or { }) ? decky-loader && config.jovian.decky-loader.enable;
in
{
  options.nixrepo.decky-loader = {
    disabledPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "CSS Loader" ];
      description = ''
        Decky plugin names to add to loader.json's disabled_plugins list before
        the Decky Loader service starts. Existing settings and disabled plugins
        are retained.
      '';
    };

    plugins = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = { };
      example = lib.literalExpression ''
        {
          "SDH-CssLoader" = pkgs.deckyPlugins."SDH-CssLoader";
        }
      '';
      description = ''
        Decky plugins to install, keyed by their exact directory name under
        plugins. Each package must contain the plugin files at its output root.
        Existing directories are backed up before the managed store link is
        created and restored when that plugin is removed from this set.
      '';
    };

    stateDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Decky Loader state directory. When unset, uses
        jovian.decky-loader.stateDir.
      '';
    };
  };
  config = lib.mkIf hasEnabledJovianDecky {
    systemd.services.decky-loader.preStart = lib.mkAfter ''
      ${pkgs.python3}/bin/python3 - ${lib.escapeShellArg loaderSettings} ${lib.escapeShellArg "${stateDir}/plugins"} ${
        lib.escapeShellArg (builtins.toJSON (lib.mapAttrs (_: package: toString package) cfg.plugins))
      } ${lib.escapeShellArgs cfg.disabledPlugins} <<'PY'
      import json
      import os
      import pathlib
      import sys
      import tempfile

      settings_path = pathlib.Path(sys.argv[1])
      plugin_root = pathlib.Path(sys.argv[2])
      desired = json.loads(sys.argv[3])
      requested = sys.argv[4:]
      settings_path.parent.mkdir(parents=True, exist_ok=True)

      if requested:
          parent_stat = settings_path.parent.stat()
          flags = os.O_RDWR | os.O_CLOEXEC | getattr(os, "O_NOFOLLOW", 0)
          try:
              fd = os.open(settings_path, flags)
          except FileNotFoundError:
              fd = os.open(settings_path, flags | os.O_CREAT | os.O_EXCL, 0o644)
              os.fchown(fd, parent_stat.st_uid, parent_stat.st_gid)

          with os.fdopen(fd, "r+", encoding="utf-8") as settings_file:
              contents = settings_file.read()
              if contents.strip():
                  try:
                      settings = json.loads(contents)
                  except json.JSONDecodeError as error:
                      raise SystemExit(f"Invalid Decky settings JSON at {settings_path}: {error}")
              else:
                  settings = {}
              if not isinstance(settings, dict):
                  raise SystemExit(f"Decky settings at {settings_path} must be a JSON object")

              disabled = settings.setdefault("disabled_plugins", [])
              if not isinstance(disabled, list) or not all(isinstance(name, str) for name in disabled):
                  raise SystemExit(f"disabled_plugins in {settings_path} must be a list of strings")

              merged = disabled + [name for name in requested if name not in disabled]
              if merged != disabled:
                  settings["disabled_plugins"] = merged
                  settings_file.seek(0)
                  json.dump(settings, settings_file, indent=4)
                  settings_file.write("\n")
                  settings_file.truncate()

      # Only paths recorded in this manifest belong to the Nix module.
      plugin_root.mkdir(parents=True, exist_ok=True)
      manifest_path = plugin_root / ".nixrepo-managed-plugins.json"
      backup_root = plugin_root / ".nixrepo-plugin-backups"
      manifest = json.loads(manifest_path.read_text()) if manifest_path.exists() else {}
      if not isinstance(manifest, dict):
          raise SystemExit(f"Invalid Decky plugin manifest at {manifest_path}")

      def plugin_path(name):
          if not name or name in (".", "..") or pathlib.Path(name).name != name:
              raise SystemExit(f"Invalid Decky plugin directory name: {name!r}")
          return plugin_root / name

      # Remove only module-managed links; preserve a path another tool replaced.
      for name in list(manifest):
          if name in desired:
              continue
          destination = plugin_path(name)
          previous = manifest[name]
          if os.path.islink(destination) and os.readlink(destination) == previous["target"]:
              destination.unlink()
          elif os.path.lexists(destination):
              continue
          backup = backup_root / name
          if previous.get("backed_up") and os.path.lexists(backup) and not os.path.lexists(destination):
              os.replace(backup, destination)
          del manifest[name]

      for name, target in desired.items():
          destination = plugin_path(name)
          target = str(pathlib.Path(target))
          if not pathlib.Path(target).is_dir():
              raise SystemExit(f"Decky plugin package for {name} is not a directory: {target}")
          previous = manifest.get(name)
          if previous is None:
              backed_up = False
              if os.path.lexists(destination):
                  backup_root.mkdir(mode=0o700, exist_ok=True)
                  backup = backup_root / name
                  if os.path.lexists(backup):
                      raise SystemExit(f"Refusing to overwrite Decky plugin backup {backup}")
                  os.replace(destination, backup)
                  backed_up = True
              os.symlink(target, destination)
          else:
              old_target = previous["target"]
              if os.path.islink(destination):
                  current_target = os.readlink(destination)
                  if current_target not in (old_target, target):
                      raise SystemExit(f"Refusing to replace unmanaged Decky plugin link {destination}")
                  if current_target != target:
                      temporary_fd, temporary_name = tempfile.mkstemp(
                          prefix=f".{name}.nixrepo-", dir=plugin_root
                      )
                      os.close(temporary_fd)
                      temporary_link = pathlib.Path(temporary_name)
                      temporary_link.unlink()
                      os.symlink(target, temporary_link)
                      os.replace(temporary_link, destination)
              elif os.path.lexists(destination):
                  raise SystemExit(f"Refusing to replace unmanaged Decky plugin path {destination}")
              else:
                  os.symlink(target, destination)
              backed_up = previous.get("backed_up", False)
          manifest[name] = {"target": target, "backed_up": backed_up}

      temporary_fd, temporary_name = tempfile.mkstemp(
          prefix=f".{manifest_path.name}-", dir=plugin_root
      )
      temporary_manifest = pathlib.Path(temporary_name)
      with os.fdopen(temporary_fd, "w", encoding="utf-8") as manifest_file:
          manifest_file.write(json.dumps(manifest, indent=2) + "\n")
      os.chmod(temporary_manifest, 0o600)
      os.replace(temporary_manifest, manifest_path)
      PY
    '';
  };
}
