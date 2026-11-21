final: prev: {
  awscli = prev.awscli.overridePythonAttrs (import ./awscli.nix { pkgs = final; });

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
