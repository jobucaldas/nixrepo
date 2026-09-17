# nixrepo

Personal Nix packages and reusable NixOS modules.

## Flake outputs

- `overlays.default`: adds all packages to `pkgs`
- `packages.x86_64-linux`: helium, vacuumtube, crunchyroll-linux, unofficial-homestuck-collection, wispr-flow, xhisper-local, xhisper-whisper-cpp
- `nixosModules.default`: imports all reusable modules
- `nixosModules.web-apps`: reusable declarative web-app desktop entries
- `nixosModules.gamescope-rx570`: Gamescope compatibility patch for latest DRM regression
- `nixosModules.dictation`: system-wide voice dictation (xhisper-whisper-cpp, xhisper-local, and wispr-flow backends)

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
`pkgs.crunchyroll-linux`, `pkgs.unofficial-homestuck-collection`,
`pkgs.wispr-flow`, `pkgs.xhisper-local`, and `pkgs.xhisper-whisper-cpp`.

## Extras

Enable the RX 570 Gamescope workaround on affected machines:

```nix
nixrepo.gamescope.rx570.enable = true;
```

Enable offline dictation (defaults to the whisper-cpp backend):

```nix
nixrepo.dictation = {
  enable = true;
  backend = "xhisper-whisper-cpp"; # or "xhisper-local" or "wispr-flow"
};
```
