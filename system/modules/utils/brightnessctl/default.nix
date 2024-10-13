{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.utils.brightnessctl;
in {
  options = {
    systemModules.utils.brightnessctl.enable = mkEnableOption "Enables brigthnessctl";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.brightnessctl
    ];
  };
}
