{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.psd;
in {
  options = {
    nixos.services.psd.enable = mkEnableOption "Enables Profile Sync Daemon";
  };
  config = mkIf cfg.enable {
    services.psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };
}
