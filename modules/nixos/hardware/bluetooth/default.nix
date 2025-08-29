{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.hardware.bluetooth;
in
{
  options = {
    nixos.hardware.bluetooth.enable = mkEnableOption "Enables bluetooth";
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
