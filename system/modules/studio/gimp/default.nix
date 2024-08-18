{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.studio.gimp;
in {
  options = {
    modules.studio.gimp.enable = mkEnableOption "Enables gimp";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gimp-with-plugins
    ];
  };
}
