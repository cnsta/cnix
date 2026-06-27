{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.gnome;
in {
  options = {
    cnix.programs.gnome.enable = mkEnableOption "Enables gnome";
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
