{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.services.udiskie;
in {
  options = {
    home.services.udiskie.enable = mkEnableOption "Enables udiskie";
  };
  config = mkIf cfg.enable {
    services.udiskie = {
      enable = true;
      tray = "always";
      notify = false;
    };
    systemd.user.services.udiskie.Unit.After = lib.mkForce "graphical-session.target";
  };
}
