{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.gaming.lutris;
in {
  options = {
    systemModules.gaming.lutris.enable = mkEnableOption "Enables lutris";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
    ];
  };
}
