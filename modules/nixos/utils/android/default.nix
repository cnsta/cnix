{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.utils.android;
in {
  options = {
    nixos.utils.android.enable = mkEnableOption "Enables android tools";
  };
  config = mkIf cfg.enable {
    programs.adb.enable = true;
  };
}
