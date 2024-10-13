{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.system.pcscd;
in {
  options = {
    systemModules.sysd.system.pcscd.enable = mkEnableOption "Enables pcscd";
  };
  config = mkIf cfg.enable {
    services.pcscd.enable = true;
  };
}
