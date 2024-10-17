{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.userd.udiskie;
in {
  options = {
    home.userd.udiskie.enable = mkEnableOption "Enables udiskie";
  };
  config = mkIf cfg.enable {
    services.udiskie = {
      enable = true;
      tray = "always";
      notify = false;
    };
  };
}
