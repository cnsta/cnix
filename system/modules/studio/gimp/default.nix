{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.studio.gimp;
in {
  options = {
    systemModules.studio.gimp.enable = mkEnableOption "Enables gimp";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gimp-with-plugins
    ];
  };
}
