{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.hardware.bluetooth;
in {
  options = {
    system.hardware.bluetooth.enable = mkEnableOption "Enables bluetooth";
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
