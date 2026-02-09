{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.blender;
in
{
  options = {
    nixos.programs.blender = {
      enable = mkEnableOption "Enables Blender";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.blender
    ];
  };
}
