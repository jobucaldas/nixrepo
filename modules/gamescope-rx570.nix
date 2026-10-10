{
  config,
  lib,
  ...
}:
let
  cfg = config.nixrepo.gamescope.rx570;
in
{
  options.nixrepo.gamescope.rx570.enable = lib.mkEnableOption ''
    Gamescope compatibility workarounds for RX 570-class GPUs
  '';

  config = lib.mkIf cfg.enable {
    # Use implicit synchronization for RX 570 sessions.
    systemd.user.services.gamescope-session.environment.gamescope_drm_debug_disable_explicit_sync =
      "true";

    nixpkgs.overlays = [
      (_final: prev: {
        gamescope = prev.gamescope.overrideAttrs (
          old:
          if old.version == "3.16.28" then
            {
              patches = (old.patches or [ ]) ++ [
                ../patches/gamescope-rx570.patch
              ];
            }
          else
            { }
        );
      })
    ];
  };
}
