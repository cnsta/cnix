{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  unit = "jellyfin-mpv-shim";
  cfg = config.home.services.jellyfin-mpv-shim;
in
{
  options = {
    home.services.${unit}.enable = mkEnableOption "Enables ${unit}";
  };
  config = mkIf cfg.enable {
    systemd.user.services.jellyfin-mpv-shim = {
      Unit = {
        Description = "Jellyfin MPV Shim";
        After = [
          "network-online.target"
          "tailscaled.service"
        ];
        Wants = [ "network-online.target" ];
        ConditionPathExists = "/sys/class/net/tailscale0";
      };
      Service = {
        ExecStart = "${pkgs.jellyfin-mpv-shim}/bin/jellyfin-mpv-shim";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
