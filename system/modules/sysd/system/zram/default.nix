{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.system.zram;
in {
  options = {
    systemModules.sysd.system.zram.enable = mkEnableOption "Enables zram";
  };
  config = mkIf cfg.enable {
    zramSwap.enable = true;
  };
}
