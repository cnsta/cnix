{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.dbus;
in {
  options = {
    modules.sysd.dbus.enable = mkEnableOption "Enables dbus";
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
