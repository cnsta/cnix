{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.udisks;
in {
  options = {
    modules.sysd.udisks.enable = mkEnableOption "Enables udisks";
  };
  config = mkIf cfg.enable {
    services.udisks2.enable = true;
  };
}
