{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.gimp;
in {
  options = {
    nixos.programs.gimp.enable = mkEnableOption "Enables gimp";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gimp3-with-plugins
    ];
  };
}
