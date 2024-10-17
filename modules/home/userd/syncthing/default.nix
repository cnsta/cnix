{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.userd.syncthing;
in {
  options = {
    home.userd.syncthing.enable = mkEnableOption "Enables syncthing";
  };
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray.enable = false;
    };
  };
}
