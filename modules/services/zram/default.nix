{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.services.zram;
in {
  options.cnix.services.zram.enable = mkEnableOption "Enables zram";

  config = mkIf cfg.enable {
    zramSwap.enable = true;
  };
}
