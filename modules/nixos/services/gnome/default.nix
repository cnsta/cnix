{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.gnome;
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
    ];
    services.gnome = {
      gnome-keyring.enable = mkIf cfg.keyring.enable true;
      evolution-data-server.enable = mkIf cfg.evolution-data-server.enable true;
    };
  };
}
