# nixrepo

Personal Nix packages and reusable NixOS modules.

## Flake outputs

- `overlays.default`: adds all packages to `pkgs`
- `overlays.patches`: packaging fixes, also included in `overlays.default`
- `packages.x86_64-linux`: epic-games-launcher, helium, prime-wine, vacuumtube, crunchyroll-linux, unofficial-homestuck-collection, wispr-flow, xhisper-local, xhisper-whisper-cpp, xodus-nexus
- `nixosModules.default`: imports all reusable modules
- `nixosModules.web-apps`: reusable declarative web-app desktop entries
- `nixosModules.gamescope-rx570`: RX 570 Gamescope format-selection backport for 3.16.28
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

Packages are then available as `pkgs.epic-games-launcher`, `pkgs.helium`, `pkgs.prime-wine`, `pkgs.vacuumtube`,
`pkgs.crunchyroll-linux`, `pkgs.unofficial-homestuck-collection`,
`pkgs.wispr-flow`, `pkgs.xhisper-local`, `pkgs.xhisper-whisper-cpp`, and `pkgs.xodus-nexus`.

Launch Prime Video (`prime-wine`) and select Install on first run to download
Wine and Brave into your user data directory. Use `prime-wine --manage` to
update Brave or manage the installation.

## Extras

The patches overlay fixes xpad-noone's module installation for the kernel
signature and certificate requirements in newer nixpkgs. It applies to all
kernel package sets without changing the selected kernel. The
`checks.x86_64-linux.xpad-noone-modules` check builds the combined kernel and
xpad-noone module tree.

Enable the RX 570 Gamescope workaround on affected machines:

```nix
nixrepo.gamescope.rx570.enable = true;
```

The module applies a format-selection backport to Gamescope 3.16.28.

Enable offline dictation (defaults to the whisper-cpp backend):

```nix
nixrepo.dictation = {
  enable = true;
  backend = "xhisper-whisper-cpp"; # or "xhisper-local" or "wispr-flow"
};
```

## Automatic AppImage updates

The daily `update-appimages.yml` workflow discovers packages through
`passthru.updateInfo`. GitHub releases use `repo` and `assetRegex`. Redirect-based
downloads use `type = "redirect"`, `url`, and a `versionRegex` with a named
`version` capture. The updater follows Epic's installer endpoint, reads the
version from the decoded download URL, and updates the pinned version and hash.
All updated packages are built before the workflow commits them.
