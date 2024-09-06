{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.system.pcscd;
in {
  options = {
    modules.sysd.system.pcscd.enable = mkEnableOption "Enables pcscd";
  };
  config = mkIf cfg.enable {
    services.pcscd.enable = true;
  };
}
