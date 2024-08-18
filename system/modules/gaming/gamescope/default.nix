{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.gaming.gamescope;
in {
  options = {
    modules.gaming.gamescope.enable = mkEnableOption "Enables gamescope";
  };
  config = mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
  };
}
