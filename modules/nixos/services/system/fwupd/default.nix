{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.system.fwupd;
in {
  options = {
    nixos.services.system.fwupd.enable = mkEnableOption "Enables fwupd";
  };
  config = mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
