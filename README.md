# nixrepo

Personal Nix packages and reusable NixOS modules.

## Flake outputs

- `overlays.default`: adds all packages to `pkgs`
- `packages.x86_64-linux`: directly buildable package outputs
- `nixosModules.default`: imports all reusable modules
- `nixosModules.web-apps`: reusable declarative web-app desktop entries
- `nixosModules.gamescope-rx570`: Gamescope compatibility patch for latest DRM regression

## Import packages from another flake

```nix
inputs.nixrepo = {
  url = "github:jobucaldas/nixrepo";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Apply the overlay and import the modules:

```nix
{
  imports = [ inputs.nixrepo.nixosModules.default ];
  nixpkgs.overlays = [ inputs.nixrepo.overlays.default ];
}
```

Packages are then available as `pkgs.helium`, `pkgs.vacuumtube`,
`pkgs.crunchyroll-linux`, and `pkgs.unofficial-homestuck-collection`.

## Extras

Enable the RX 570 Gamescope workaround on affected machines:

```nix
nixrepo.gamescope.rx570.enable = true;
```
