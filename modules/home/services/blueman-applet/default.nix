{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.services.blueman-applet;
in
{
  options = {
    home.services.blueman-applet.enable = mkEnableOption "Enables blueman-applet";
  };
  config = mkIf cfg.enable {
    services.blueman-applet = {
      enable = true;
    };
  };
}
