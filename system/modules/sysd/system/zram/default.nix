{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.system.zram;
in {
  options = {
    modules.sysd.system.zram.enable = mkEnableOption "Enables zram";
  };
  config = mkIf cfg.enable {
    zramSwap.enable = true;
  };
}
