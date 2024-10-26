{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.gaming.lutris;
in {
  options = {
    nixos.gaming.lutris.enable = mkEnableOption "Enables lutris";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
      bottles
      wineWowPackages.waylandFull
      wineWowPackages.stagingFull
    ];
  };
}
