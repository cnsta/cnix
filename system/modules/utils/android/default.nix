{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.android;
in {
  options = {
    modules.utils.android.enable = mkEnableOption "Enables android tools";
  };
  config = mkIf cfg.enable {
    programs.adb.enable = true;
  };
}
