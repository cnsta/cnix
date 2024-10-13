{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.network.blueman;
in {
  options = {
    systemModules.sysd.network.blueman.enable = mkEnableOption "Enables blueman";
  };
  config = mkIf cfg.enable {
    services = {
      blueman.enable = true;
    };
  };
}
