{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.userd.blueman-applet;
in {
  options = {
    userModules.userd.blueman-applet.enable = mkEnableOption "Enables blueman-applet";
  };
  config = mkIf cfg.enable {
    services.blueman-applet = {
      enable = true;
    };
  };
}
