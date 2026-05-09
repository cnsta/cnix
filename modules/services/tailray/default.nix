{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cnix.services.tailray;
  tailray = inputs.tailray.packages.${pkgs.stdenv.hostPlatform.system}.tailray;
in
{
  options.cnix.services.tailray.enable = mkEnableOption "tailray";

  config = mkIf cfg.enable {
    environment.systemPackages = [ tailray ];

    systemd.user.services.tailray = {
      description = "Tailray (Tailscale tray)";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      path = [ pkgs.tailscale ];
      serviceConfig = {
        ExecStart = lib.getExe tailray;
        Restart = "on-failure";
        RestartSec = "10";
      };
      environment.TAILRAY_THEME = "dark";
    };
  };
}
