{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.session.dbus;
in {
  options = {
    systemModules.sysd.session.dbus.enable = mkEnableOption "Enables dbus";
  };
  config = mkIf cfg.enable {
    services.dbus = {
      enable = true;
      packages = with pkgs; [
        gcr
      ];
    };
  };
}
