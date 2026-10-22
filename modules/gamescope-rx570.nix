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
    nixpkgs.overlays = [
      (final: prev: {
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

        # Jovian's Steam session has its own package scope. Use the current
        # nixpkgs Gamescope here too, including any RX 570 compatibility patch.
        jovianPackages = prev.jovianPackages.overrideScope (
          _self: _super: {
            gamescope = final.gamescope;
          }
        );
      })
    ];
  };
}
