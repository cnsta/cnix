{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.utils.anyrun;
in {
  options = {
    systemModules.utils.anyrun.enable = mkEnableOption "Enables anyrun";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.anyrun
    ];
  };
}
