{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.system.powerd;
in {
  options = {
    systemModules.sysd.system.powerd.enable = mkEnableOption "Enables power-profiles-daemon";
  };
  config = mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
