{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.userd.udiskie;
in {
  options = {
    userModules.userd.udiskie.enable = mkEnableOption "Enables udiskie";
  };
  config = mkIf cfg.enable {
    services.udiskie = {
      enable = true;
      tray = "always";
      notify = false;
    };
  };
}
