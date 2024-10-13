{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.system.gvfs;
in {
  options = {
    systemModules.sysd.system.gvfs.enable = mkEnableOption "Enables gvfs";
  };
  config = mkIf cfg.enable {
    services.gvfs.enable = true;
  };
}
