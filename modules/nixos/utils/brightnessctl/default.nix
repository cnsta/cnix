{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.utils.brightnessctl;
in {
  options = {
    nixos.utils.brightnessctl.enable = mkEnableOption "Enables brigthnessctl";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.brightnessctl
    ];
  };
}
