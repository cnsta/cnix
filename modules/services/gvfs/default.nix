{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.services.gvfs;
in
{
  options.cnix.services.gvfs.enable = mkEnableOption "Enables gvfs";

  config = mkIf cfg.enable {
    services.gvfs.enable = true;
  };
}
