{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.system.powerd;
in {
  options = {
    nixos.services.system.powerd.enable = mkEnableOption "Enables power-profiles-daemon";
  };
  config = mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
