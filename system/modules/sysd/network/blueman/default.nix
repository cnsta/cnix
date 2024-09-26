{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.network.blueman;
in {
  options = {
    modules.sysd.network.blueman.enable = mkEnableOption "Enables blueman";
  };
  config = mkIf cfg.enable {
    services = {
      blueman.enable = true;
      blueman-applet.enable = true;
    };
  };
}
