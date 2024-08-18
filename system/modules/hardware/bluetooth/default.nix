{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.hardware.bluetooth;
in {
  options = {
    modules.hardware.bluetooth.enable = mkEnableOption "Enables bluetooth";
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
