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
    the Gamescope modifierless Vulkan compatibility patch for RX 570-class GPUs
  '';

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (_final: prev: {
        gamescope = prev.gamescope.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [
            ../patches/gamescope-rx570.patch
          ];
        });
      })
    ];
  };
}
