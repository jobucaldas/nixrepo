{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.webApps;

  mkWebApp =
    id: app:
    let
      iconStr = if app.icon != null then toString app.icon else cfg.browser.meta.mainProgram or null;
    in
    pkgs.makeDesktopItem {
      name = id;
      desktopName = app.name;
      genericName = app.genericName;
      comment = app.comment;
      icon = iconStr;
      exec = lib.concatStringsSep " " (
        [ (lib.getExe cfg.browser) ] ++ app.extraArgs ++ [ "--app=${app.url}" ]
      );
      terminal = app.terminal;
      categories = app.categories;
      keywords = app.keywords;
      startupNotify = app.startupNotify;
      startupWMClass = app.startupWMClass;
      extraConfig = app.extraConfig;
    };
in
{
  options.webApps = {
    browser = lib.mkOption {
      type = lib.types.package;
      description = "Browser package used to launch installed web applications";
    };

    entries = lib.mkOption {
      default = { };
      description = "Web applications to expose as desktop entries";

      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                default = name;
                description = "Name shown in application launchers";
              };

              url = lib.mkOption {
                type = lib.types.str;
                description = "URL opened by the browser's app mode";
              };

              genericName = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };

              comment = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };

              icon = lib.mkOption {
                type = lib.types.nullOr (
                  lib.types.either lib.types.str (lib.types.either lib.types.path lib.types.package)
                );
                default = null;
                description = "Desktop icon name or absolute path; accepts theme icon names, store paths (e.g. pkgs.fetchurl result), or packages. Defaults to the browser icon";
              };

              extraArgs = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Arguments passed to the browser before the app URL";
              };

              terminal = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };

              categories = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ "Network" ];
              };

              keywords = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };

              startupNotify = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
              };

              startupWMClass = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };

              extraConfig = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                default = { };
                description = "Additional keys written to the desktop entry";
              };
            };
          }
        )
      );
    };
  };

  config.environment.systemPackages = [ cfg.browser ] ++ lib.mapAttrsToList mkWebApp cfg.entries;
}
