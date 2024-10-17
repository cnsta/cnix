{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.gaming.lutris;
in {
  options = {
    system.gaming.lutris.enable = mkEnableOption "Enables lutris";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
    ];
  };
}
