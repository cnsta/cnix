{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.utils.brightnessctl;
in {
  options = {
    system.utils.brightnessctl.enable = mkEnableOption "Enables brigthnessctl";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.brightnessctl
    ];
  };
}
