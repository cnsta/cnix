{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.hardware.logitech;
in {
  options = {
    system.hardware.logitech.enable = mkEnableOption "Enables logitech";
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
