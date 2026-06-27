{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.blender;
in {
  options = {
    cnix.programs.blender = {
      enable = mkEnableOption "Enables Blender";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.blender
    ];
  };
}
