{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.gnome;
in {
  options = {
    nixos.programs.gnome.enable = mkEnableOption "Enables gnome";
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
