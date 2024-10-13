{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.system.fwupd;
in {
  options = {
    systemModules.sysd.system.fwupd.enable = mkEnableOption "Enables fwupd";
  };
  config = mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
