{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.services.psd;
in
{
  options.cnix.services.psd.enable = mkEnableOption "Enables Profile Sync Daemon";

  config = mkIf cfg.enable {
    services.psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };
}
