{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixrepo.dictation;

  xhisperPkg =
    if cfg.backend == "xhisper-whisper-cpp" then
      pkgs.xhisper-whisper-cpp
    else if cfg.backend == "xhisper-local" then
      pkgs.xhisper-local
    else
      null;
  isXhisper = xhisperPkg != null;
in
{
  options.nixrepo.dictation = {
    enable = lib.mkEnableOption "system-wide voice dictation";

    backend = lib.mkOption {
      type = lib.types.enum [
        "xhisper-whisper-cpp"
        "xhisper-local"
        "wispr-flow"
      ];
      default = "xhisper-whisper-cpp";
      description = "Dictation backend. whisper-cpp is the offline default, faster-whisper the fallback, wispr-flow the pinned upstream AppImage.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "jobu";
      description = "User to grant input/uinput access for keystroke injection.";
    };

    enableWhisperCppVulkan = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the whisper-cpp-vulkan CLI for manual use.";
    };

    enableOllama = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install ollama (CPU) for xhisper-local LLM post-processing. Off by default: heavy + hallucinates commands.";
    };

    wisprFlowPackage = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.wispr-flow;
      defaultText = "pkgs.wispr-flow";
      description = ''
        Wispr Flow package installed by the "wispr-flow" backend.
        Defaults to the pinned upstream AppImage in this repo; override
        to pin another build, or set to null to install open deps only.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        users.users.${cfg.user}.extraGroups = [ "input" ];

        services.udev.extraRules = ''
          KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess", GROUP="input", MODE="0660"
        '';

        environment.systemPackages =
          with pkgs;
          [
            wl-clipboard
            wtype
          ]
          ++ lib.optional cfg.enableWhisperCppVulkan whisper-cpp-vulkan
          ++ lib.optional cfg.enableOllama ollama;
      }

      (lib.mkIf isXhisper {
        environment.systemPackages = with pkgs; [
          xhisperPkg
          ffmpeg
          pipewire
          procps
          bc
        ];

        systemd.user.services.xhispertoold = {
          description = "xhisper uinput injection daemon";
          wantedBy = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            ExecStart = "${xhisperPkg}/bin/xhispertoold";
            Restart = "on-failure";
          };
        };

        environment.etc."xhisper/default_xhisperrc.example".source =
          "${xhisperPkg}/share/xhisper/default_xhisperrc";
      })

      (lib.mkIf (cfg.backend == "wispr-flow") {
        environment.systemPackages =
          with pkgs;
          [
            xclip
            xsel
          ]
          ++ lib.optional (cfg.wisprFlowPackage != null) cfg.wisprFlowPackage;

        services.udev.extraRules = ''
          SUBSYSTEM=="input", KERNEL=="event*", TAG+="uaccess", GROUP="input", MODE="0660"
        '';

        warnings = lib.optional (cfg.wisprFlowPackage == null) ''
          nixrepo.dictation: backend "wispr-flow" selected but nixrepo.dictation.wisprFlowPackage is null.
          Only open deps + udev rules installed; set it to pkgs.wispr-flow (default) to install the app.
        '';
      })
    ]
  );
}
