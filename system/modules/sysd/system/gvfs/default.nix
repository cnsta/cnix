{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.system.gvfs;
in {
  options = {
    modules.sysd.system.gvfs.enable = mkEnableOption "Enables gvfs";
  };
  config = mkIf cfg.enable {
    services.gvfs.enable = true;
  };
}
