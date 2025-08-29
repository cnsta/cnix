{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.zram;
in
{
  options = {
    nixos.services.zram.enable = mkEnableOption "Enables zram";
  };
  config = mkIf cfg.enable {
    zramSwap.enable = true;
  };
}
