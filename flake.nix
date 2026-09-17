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
            # `nix flake check` / `nix build` stay pure.
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

      checks = forAllSystems (
        system:
        let
          baseModule = {
            nixpkgs.hostPlatform = system;
            nixpkgs.overlays = [ self.overlays.default ];
            nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "wispr-flow" ];
            boot.isContainer = true;
            system.stateVersion = "25.11";
          };

          mkNixosEvalCheck =
            name: extraModules:
            let
              evaluated = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [ baseModule ] ++ extraModules;
              };
              pkgPaths = builtins.map (
                p: if builtins.isAttrs p then p.drvPath or p.outPath or "non-derivation" else builtins.toString p
              ) evaluated.config.environment.systemPackages;
              svcExecs = builtins.attrValues (
                builtins.mapAttrs (
                  _: s: s.serviceConfig.ExecStart or "no-exec"
                ) evaluated.config.systemd.user.services
              );
              udevRules = [ evaluated.config.services.udev.extraRules ];
              etcSources = builtins.attrValues (
                builtins.mapAttrs (_: v: v.source or "no-source") evaluated.config.environment.etc
              );
              forceAll =
                xs:
                builtins.foldl' (
                  acc: x: builtins.seq (builtins.unsafeDiscardStringContext (builtins.toString x)) acc
                ) true xs;
              forcePkgs = forceAll pkgPaths;
              forceSvcs = forceAll svcExecs;
              forceUdev = forceAll udevRules;
              forceEtc = forceAll etcSources;
            in
            assert forcePkgs && forceSvcs && forceUdev && forceEtc;
            nixpkgs.legacyPackages.${system}.runCommand name { } ''
              echo "packages=${toString (builtins.length pkgPaths)} services=${toString (builtins.length svcExecs)}" > $out
            '';
        in
        {
          nixos-default = mkNixosEvalCheck "nixos-default" [ self.nixosModules.default ];

          dictation-xhisper-whisper-cpp = mkNixosEvalCheck "dictation-xhisper-whisper-cpp" [
            self.nixosModules.dictation
            {
              nixrepo.dictation.enable = true;
              nixrepo.dictation.backend = "xhisper-whisper-cpp";
            }
          ];

          dictation-xhisper-local = mkNixosEvalCheck "dictation-xhisper-local" [
            self.nixosModules.dictation
            {
              nixrepo.dictation.enable = true;
              nixrepo.dictation.backend = "xhisper-local";
            }
          ];

          dictation-wispr-flow = mkNixosEvalCheck "dictation-wispr-flow" [
            self.nixosModules.dictation
            {
              nixrepo.dictation.enable = true;
              nixrepo.dictation.backend = "wispr-flow";
            }
          ];

          web-apps-with-entry = mkNixosEvalCheck "web-apps-with-entry" [
            self.nixosModules.default
            (
              { pkgs, ... }:
              {
                webApps.browser = pkgs.helium;
                webApps.entries.youtube = {
                  url = "https://youtube.com";
                };
              }
            )
          ];
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
