{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.userd.syncthing;
in {
  options = {
    userModules.userd.syncthing.enable = mkEnableOption "Enables syncthing";
  };
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray.enable = false;
    };
  };
}
