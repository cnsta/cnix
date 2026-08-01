{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.cnix.services.zram;
in {
  options.cnix.services.zram = {
    enable = mkEnableOption "Enables zram";
    memoryPercent = mkOption {
      type = types.int;
      default = 50;
      description = "Percentage of RAM to use as compressed swap.";
    };
  };

  config = mkIf cfg.enable {
    zramSwap = {
      enable = true;
      inherit (cfg) memoryPercent;
      algorithm = "zstd";
    };
  };
}
