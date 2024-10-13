{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.system.udisks;
in {
  options = {
    systemModules.sysd.system.udisks.enable = mkEnableOption "Enables udisks";
  };
  config = mkIf cfg.enable {
    services.udisks2.enable = true;
  };
}
