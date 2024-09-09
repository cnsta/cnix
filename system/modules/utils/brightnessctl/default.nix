{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.brightnessctl;
in {
  options = {
    modules.utils.brightnessctl.enable = mkEnableOption "Enables brigthnessctl";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.brightnessctl
    ];
  };
}
