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

        default = {
          imports = [
            self.nixosModules.web-apps
            self.nixosModules.gamescope-rx570
          ];
        };
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
