{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.services.fwupd;
in
{
  options.cnix.services.fwupd.enable = mkEnableOption "Enables fwupd";

  config = mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
