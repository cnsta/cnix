{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.hardware.logitech;
in {
  options = {
    nixos.hardware.logitech.enable = mkEnableOption "Enables logitech";
  };
  config = mkIf cfg.enable {
    hardware = {
      logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };
    };
  };
}
