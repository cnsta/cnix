{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.lutris;
in
{
  options = {
    nixos.programs.lutris.enable = mkEnableOption "Enables lutris";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
    ];
  };
}
