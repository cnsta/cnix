{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.android;
in {
  options = {
    nixos.programs.android.enable = mkEnableOption "Enables android tools";
  };
  config = mkIf cfg.enable {
    programs.adb.enable = true;
  };
}
