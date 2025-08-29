{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.services.syncthing;
in
{
  options = {
    home.services.syncthing.enable = mkEnableOption "Enables syncthing";
  };
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray.enable = false;
    };
  };
}
