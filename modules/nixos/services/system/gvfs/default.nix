{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.system.gvfs;
in {
  options = {
    nixos.services.system.gvfs.enable = mkEnableOption "Enables gvfs";
  };
  config = mkIf cfg.enable {
    services.gvfs.enable = true;
  };
}
