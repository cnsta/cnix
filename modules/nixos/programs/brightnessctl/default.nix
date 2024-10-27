{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.brightnessctl;
in {
  options = {
    nixos.programs.brightnessctl.enable = mkEnableOption "Enables brigthnessctl";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.brightnessctl
    ];
  };
}
