{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.services.udisks;
in
{
  options.cnix.services.udisks.enable = mkEnableOption "Enables udisks";

  config = mkIf cfg.enable {
    services.udisks2.enable = true;
  };
}
