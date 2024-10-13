{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.utils.corectrl;
in {
  options = {
    systemModules.utils.corectrl.enable = mkEnableOption "Enables CoreCtrl";
  };
  config = mkIf cfg.enable {
    programs.corectrl = {
      enable = true;
      gpuOverclock = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
    };
  };
}
