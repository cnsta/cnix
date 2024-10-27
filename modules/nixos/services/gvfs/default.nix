{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.gvfs;
in {
  options = {
    nixos.services.gvfs.enable = mkEnableOption "Enables gvfs";
  };
  config = mkIf cfg.enable {
    services.gvfs.enable = true;
  };
}
