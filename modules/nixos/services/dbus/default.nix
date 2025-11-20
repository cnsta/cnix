{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.dbus;
in
{
  options = {
    nixos.services.dbus.enable = mkEnableOption "Enables dbus";
  };
  config = mkIf cfg.enable {
    services.dbus = {
      enable = true;
      implementation = "broker";
      packages = with pkgs; [
        gnome-settings-daemon
        gcr
      ];
    };
  };
}
