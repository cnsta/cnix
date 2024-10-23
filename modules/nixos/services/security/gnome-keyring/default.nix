{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.security.gnome-keyring;
in {
  options = {
    nixos.services.security.gnome-keyring.enable = mkEnableOption "Enables gnome-keyring";
  };
  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
  };
}
