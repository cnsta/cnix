{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.sysd.network.blueman;
in {
  options = {
    system.sysd.network.blueman.enable = mkEnableOption "Enables blueman";
  };
  config = mkIf cfg.enable {
    services = {
      blueman.enable = true;
    };
  };
}
