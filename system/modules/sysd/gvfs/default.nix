{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.gvfs;
in {
  options = {
    modules.sysd.gvfs.enable = mkEnableOption "Enables gvfs";
  };
  config = mkIf cfg.enable {
    services.gvfs.enable = true;
  };
}
