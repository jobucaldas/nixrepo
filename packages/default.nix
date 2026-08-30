final: _prev:
let
  mkAppImage = final.callPackage ../helpers/appimage.nix { };
  callAppImage = package: final.callPackage package { inherit mkAppImage; };
in
{
  crunchyroll-linux = callAppImage ./crunchyroll-linux.nix;
  helium = callAppImage ./helium.nix;
  unofficial-homestuck-collection = callAppImage ./unofficial-homestuck-collection.nix;
  vacuumtube = callAppImage ./vacuumtube.nix;
}
