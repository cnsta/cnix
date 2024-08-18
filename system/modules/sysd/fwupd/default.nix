{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.fwupd;
in {
  options = {
    modules.sysd.fwupd.enable = mkEnableOption "Enables fwupd";
  };
  config = mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
