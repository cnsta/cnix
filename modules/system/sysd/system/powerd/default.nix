{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.sysd.system.powerd;
in {
  options = {
    system.sysd.system.powerd.enable = mkEnableOption "Enables power-profiles-daemon";
  };
  config = mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
