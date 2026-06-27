{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.services.syncthing;
in {
  options = {
    cnix.services.syncthing = {
      enable = mkEnableOption "Enables syncthing";
    };
  };
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    };
  };
}
