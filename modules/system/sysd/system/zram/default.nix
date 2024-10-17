{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.sysd.system.zram;
in {
  options = {
    system.sysd.system.zram.enable = mkEnableOption "Enables zram";
  };
  config = mkIf cfg.enable {
    zramSwap.enable = true;
  };
}
