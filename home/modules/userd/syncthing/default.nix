{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.userd.syncthing;
in {
  options = {
    modules.userd.syncthing.enable = mkEnableOption "Enables syncthing";
  };
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray.enable = true;
    };
  };
}
