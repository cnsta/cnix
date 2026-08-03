{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.services.gnome;
in {
  options = {
    cnix.services.gnome = {
      keyring.enable = mkEnableOption "Enables gnome-keyring";
      gvfs.enable = mkEnableOption "Enables gnome virtual files ystem";
    };
  };

  config = {
    services = {
      gnome = {
        gnome-keyring.enable = mkIf cfg.keyring.enable true;
      };
      gvfs.enable = mkIf cfg.gvfs.enable true;
    };
  };
}
