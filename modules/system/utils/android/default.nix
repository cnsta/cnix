{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.utils.android;
in {
  options = {
    system.utils.android.enable = mkEnableOption "Enables android tools";
  };
  config = mkIf cfg.enable {
    programs.adb.enable = true;
  };
}
