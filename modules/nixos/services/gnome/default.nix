{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.gnome;
  srv = config.nixos.services;
in
{
  options = {
    nixos.services.gnome = {
      keyring.enable = mkEnableOption "Enables gnome-keyring";
      evolution-data-server.enable = mkEnableOption "Enables evolution data server (calendar)";
    };
  };
  config = {
    environment.systemPackages = with pkgs; [
      evolution-data-server
      gcr_4
    ];
    security.pam.services = {
      login = mkIf cfg.keyring.enable {
        enable = true;
        enableGnomeKeyring = true;
      };
      greetd = mkIf (cfg.keyring.enable && srv.greetd.enable) {
        enable = true;
        enableGnomeKeyring = true;
      };
    };
    services.gnome = {
      gnome-keyring.enable = mkIf cfg.keyring.enable true;
      evolution-data-server.enable = mkIf cfg.evolution-data-server.enable true;
    };
  };
}
