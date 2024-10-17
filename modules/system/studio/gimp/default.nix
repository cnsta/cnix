{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.studio.gimp;
in {
  options = {
    system.studio.gimp.enable = mkEnableOption "Enables gimp";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gimp-with-plugins
    ];
  };
}
