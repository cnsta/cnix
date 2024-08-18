{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.gui.gnome;
in {
  options = {
    modules.gui.gnome.enable = mkEnableOption "Enables gnome";
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
