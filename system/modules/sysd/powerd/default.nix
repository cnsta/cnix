{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.powerd;
in {
  options = {
    modules.sysd.powerd.enable = mkEnableOption "Enables power-profiles-daemon";
  };
  config = mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
