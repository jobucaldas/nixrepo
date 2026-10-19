final: _prev:
let
  mkAppImage = final.callPackage ../helpers/appimage.nix { };
  callAppImage = package: final.callPackage package { inherit mkAppImage; };
in
{
  crunchyroll-linux = callAppImage ./crunchyroll-linux.nix;
  epic-games-launcher = callAppImage ./epic-games-launcher.nix;
  helium = callAppImage ./helium.nix;
  unofficial-homestuck-collection = callAppImage ./unofficial-homestuck-collection.nix;
  vacuumtube = callAppImage ./vacuumtube.nix;
  wispr-flow = callAppImage ./wispr-flow.nix;
  xodus-nexus = callAppImage ./xodus-nexus.nix;

  xhisper-local = final.callPackage ./xhisper.nix { engine = "faster-whisper"; };
  xhisper-whisper-cpp = final.callPackage ./xhisper.nix { engine = "whisper-cpp"; };
}
