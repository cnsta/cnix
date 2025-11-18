{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    types
    mkIf
    mkEnableOption
    mkOption
    ;
  cfg = config.nixos.services.power;
in
{
  options = {
    nixos.services.power = {
      enable = mkEnableOption "Enables power settings";
      cpuFreqGovernor = mkOption {
        type = types.enum [
          "ondemand"
          "powersave"
          "performance"
        ];
        description = "Selects governor mode";
        default = null;
      };
      powertop.enable = mkEnableOption "Enables powertop";
      powerProfilesDaemon.enable = mkEnableOption "Enables power-profiles-daemon";
      upower.enable = mkEnableOption "Enables upower";
    };
  };
  config = {
    powerManagement = mkIf cfg.enable {
      enable = true;
      cpuFreqGovernor = cfg.cpuFreqGovernor;
      powertop.enable = mkIf cfg.powertop.enable true;
    };
    services = {
      power-profiles-daemon.enable = mkIf cfg.powerProfilesDaemon.enable true;
      upower.enable = mkIf cfg.upower.enable true;
    };
  };
}
