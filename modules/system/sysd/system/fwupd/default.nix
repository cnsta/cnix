{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.sysd.system.fwupd;
in {
  options = {
    system.sysd.system.fwupd.enable = mkEnableOption "Enables fwupd";
  };
  config = mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
