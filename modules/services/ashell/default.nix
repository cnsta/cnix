{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.cnix.services.ashell;
in {
  options = {
    cnix.services.ashell.enable = mkEnableOption "Enables ashell as a service";
  };
  config = mkIf cfg.enable {
    systemd.user.services.ashell = {
      description = "ashell status bar";
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["tray.target"];
      serviceConfig = {
        ExecStart = lib.getExe pkgs.ashell;
        Restart = "always";
        RestartSec = 1;
        Slice = "session.slice";
      };
      unitConfig.StartLimitIntervalSec = 0;
    };
  };
}
