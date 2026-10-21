final: prev: {
  awscli = prev.awscli.overridePythonAttrs (import ./awscli.nix { pkgs = final; });

  mozc = prev.mozc.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./mozc-qt6-class-name.patch ];
  });

  kernelPackagesExtensions = prev.kernelPackagesExtensions ++ [
    (kernelFinal: kernelPrev: {
      xpad-noone = kernelPrev.xpad-noone.overrideAttrs (
        import ./xpad-noone.nix {
          inherit (final) lib;
          kernel = kernelFinal.kernel;
        }
      );
    })
  ];
}
