{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.pcscd;
in {
  options = {
    modules.sysd.pcscd.enable = mkEnableOption "Enables pcscd";
  };
  config = mkIf cfg.enable {
    services.pcscd.enable = true;
  };
}
