final: prev: {
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
