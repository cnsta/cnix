{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cnix.services.scx;
in
{
  options = {
    cnix.services.scx = {
      enable = mkEnableOption "Enables scx scheduler";
      scheduler = mkOption {
        type = types.enum [
          "scx_lavd"
          "scx_rusty"
          "scx_bpfland"
        ];
        description = "Selects the scheduler for scx";
        default = "scx_lavd";
      };
      flags = mkOption {
        type = types.str;
        description = "Custom flags to be passed to scx scheduler";
        default = "";
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      scx.rustscheds
    ];
    systemd.services.scx = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        Description = "Start scx_scheduler";
        ConditionPathIsDirectory = "/sys/kernel/sched_ext";
        StartLimitIntervalSec = 30;
        StartLimitBurst = 2;
      };
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        StandardError = "journal";
        ExecStart = "/run/current-system/sw/bin/${cfg.scheduler} ${cfg.flags}";
      };
    };
  };
}
