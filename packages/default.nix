final: _prev:
let
  mkAppImage = final.callPackage ../helpers/appimage.nix { };
  callAppImage = package: final.callPackage package { inherit mkAppImage; };
in
{
  crunchyroll-linux = callAppImage ./crunchyroll-linux.nix;
  epic-games-launcher = final.callPackage ./epic-games-launcher.nix { };
  openmausbot = callAppImage ./openmausbot.nix;
  helium = callAppImage ./helium.nix;
  prime-wine = callAppImage ./prime-wine.nix;
  unofficial-homestuck-collection = callAppImage ./unofficial-homestuck-collection.nix;
  vacuumtube = callAppImage ./vacuumtube.nix;
  wispr-flow = callAppImage ./wispr-flow.nix;
  xodus-nexus = callAppImage ./xodus-nexus.nix;

  cadcraft = callAppImage ./cadcraft.nix;
  craft-anything = callAppImage ./craft-anything.nix;
  deckcraft = callAppImage ./deckcraft.nix;
  designcraft = callAppImage ./designcraft.nix;
  effectcraft = callAppImage ./effectcraft.nix;
  figcraft = callAppImage ./figcraft.nix;
  filmcraft = callAppImage ./filmcraft.nix;
  gridcraft = callAppImage ./gridcraft.nix;
  lightcraft = callAppImage ./lightcraft.nix;
  materialcraft = callAppImage ./materialcraft.nix;
  pdfcraft = callAppImage ./pdfcraft.nix;
  photocraft = callAppImage ./photocraft.nix;
  soundcraft = callAppImage ./soundcraft.nix;
  texturecraft = callAppImage ./texturecraft.nix;
  vectorcraft = callAppImage ./vectorcraft.nix;
  wordcraft = callAppImage ./wordcraft.nix;

  xhisper-local = final.callPackage ./xhisper.nix { engine = "faster-whisper"; };
  xhisper-whisper-cpp = final.callPackage ./xhisper.nix { engine = "whisper-cpp"; };
}
