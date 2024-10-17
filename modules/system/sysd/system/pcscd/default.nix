{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.sysd.system.pcscd;
in {
  options = {
    system.sysd.system.pcscd.enable = mkEnableOption "Enables pcscd";
  };
  config = mkIf cfg.enable {
    services.pcscd.enable = true;
  };
}
