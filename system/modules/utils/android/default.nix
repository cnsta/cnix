{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.utils.android;
in {
  options = {
    systemModules.utils.android.enable = mkEnableOption "Enables android tools";
  };
  config = mkIf cfg.enable {
    programs.adb.enable = true;
  };
}
