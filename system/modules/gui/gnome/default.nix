{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.gui.gnome;
in {
  options = {
    systemModules.gui.gnome.enable = mkEnableOption "Enables gnome";
  };
  config = mkIf cfg.enable {
    services = {
      xserver = {
        desktopManager.gnome = {
          enable = true;
        };
      };
      gnome.games.enable = true;
    };
  };
}
