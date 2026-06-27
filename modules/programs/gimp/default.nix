{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.gimp;
in {
  options = {
    cnix.programs.gimp.enable = mkEnableOption "Enables gimp";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gimp3-with-plugins
    ];
  };
}
