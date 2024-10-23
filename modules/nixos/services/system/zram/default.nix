{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.system.zram;
in {
  options = {
    nixos.services.system.zram.enable = mkEnableOption "Enables zram";
  };
  config = mkIf cfg.enable {
    zramSwap.enable = true;
  };
}
