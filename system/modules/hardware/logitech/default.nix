{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.hardware.logitech;
in {
  options = {
    modules.hardware.logitech.enable = mkEnableOption "Enables logitech";
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
