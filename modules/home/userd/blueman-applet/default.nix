{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.userd.blueman-applet;
in {
  options = {
    home.userd.blueman-applet.enable = mkEnableOption "Enables blueman-applet";
  };
  config = mkIf cfg.enable {
    services.blueman-applet = {
      enable = true;
    };
  };
}
