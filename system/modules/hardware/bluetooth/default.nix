{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.hardware.bluetooth;
in {
  options = {
    systemModules.hardware.bluetooth.enable = mkEnableOption "Enables bluetooth";
  };
  config = mkIf cfg.enable {
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = false;
      };
    };
  };
}
