# nixrepo

Personal Nix packages and reusable NixOS modules.

## Flake outputs

- `overlays.default`: adds all packages to `pkgs`
- `packages.x86_64-linux`: helium, vacuumtube, crunchyroll-linux, unofficial-homestuck-collection, wispr-flow, xhisper-local, xhisper-whisper-cpp
- `overlays.default`: also exposes pinned Decky bundles at `pkgs.deckyPlugins`
- `nixosModules.default`: imports all reusable modules
- `nixosModules.web-apps`: reusable declarative web-app desktop entries
- `nixosModules.gamescope-rx570`: RX 570 Gamescope format-selection backport for 3.16.28
- `nixosModules.decky-loader`: declarative Decky plugin bundles and disabled-plugin settings
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

The module applies a format-selection backport to Gamescope 3.16.28.

Disable Decky plugins before the loader starts while preserving its existing
settings:

```nix
nixrepo.decky-loader.disabledPlugins = [ "CSS Loader" ];
```

Install pinned plugin bundles by their exact directory names. The module keeps
existing plugin directories as backups and restores them when a managed plugin
is removed from the set:

```nix
nixrepo.decky-loader.plugins = {
  "Junk-Store" = pkgs.deckyPlugins."Junk-Store";
  "SDH-CssLoader" = pkgs.deckyPlugins."SDH-CssLoader";
};
```

Change the selected `pkgs.deckyPlugins` package in Nix configuration to update
a managed plugin. Its settings, runtime data, and logs stay in Decky's existing
state directories.

`disabledPlugins` uses plugin display names (for example, `"CSS Loader"`),
while `plugins` uses the installed directory names (for example,
`"SDH-CssLoader"`).

Enable offline dictation (defaults to the whisper-cpp backend):

```nix
nixrepo.dictation = {
  enable = true;
  backend = "xhisper-whisper-cpp"; # or "xhisper-local" or "wispr-flow"
};
```
