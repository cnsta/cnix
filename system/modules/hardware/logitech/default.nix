{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.hardware.logitech;
in {
  options = {
    systemModules.hardware.logitech.enable = mkEnableOption "Enables logitech";
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
