{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.system.udisks;
in {
  options = {
    nixos.services.system.udisks.enable = mkEnableOption "Enables udisks";
  };
  config = mkIf cfg.enable {
    services.udisks2.enable = true;
  };
}
