{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.blueman;
in {
  options = {
    modules.sysd.blueman.enable = mkEnableOption "Enables blueman";
  };
  config = mkIf cfg.enable {
    services.blueman.enable = true;
  };
}