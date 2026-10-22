{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Steam's libaudio invokes pactl to query HDMI card/port availability and
  # control audio. Supplying libpulse alone does not provide that executable.
  # Use the module's extraPackages so this also reaches Jovian's Steam FHS
  # environment, which replaces the base package's extraPkgs argument.
  config = lib.mkIf config.programs.steam.enable {
    programs.steam.extraPackages = [ pkgs.pulseaudio ];
  };
}
