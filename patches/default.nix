final: prev: {
  awscli = prev.awscli.overridePythonAttrs (import ./awscli.nix { pkgs = final; });

  # Qt rejects custom widget class names that start with "::".
  # Newer mozc already dropped the prefix, and reapplying the patch fails.
  mozc = prev.mozc.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      ui=src/gui/dictionary_tool/dictionary_tool.ui
      if grep -q 'class="::mozc::gui::DictionaryContentTableWidget"' "$ui"; then
        patch -p1 < ${./mozc-qt6-class-name.patch}
      fi
    '';
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
