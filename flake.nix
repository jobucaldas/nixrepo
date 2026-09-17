{
  description = "Personal Nix packages and reusable modules";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      packageOverlay = import ./packages;
      packageNames = builtins.attrNames (packageOverlay null null);
    in
    {
      overlays.default = packageOverlay;

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            # wispr-flow is a proprietary AppImage repack; allow just it so
            # `nix flake check` / `nix build` stay pure. (Dotfiles already
            # sets allowUnfree globally for NixOS.)
            config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "wispr-flow" ];
          };
        in
        nixpkgs.lib.genAttrs packageNames (name: pkgs.${name})
        // {
          default = pkgs.helium;
        }
      );

      nixosModules = {
        web-apps = import ./helpers/web-apps.nix;
        gamescope-rx570 = import ./modules/gamescope-rx570.nix;
        dictation = import ./modules/dictation.nix;

        default = {
          imports = [
            self.nixosModules.web-apps
            self.nixosModules.gamescope-rx570
            self.nixosModules.dictation
          ];
        };
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
