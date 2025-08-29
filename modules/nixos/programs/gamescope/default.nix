{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.gamescope;
in
{
  options = {
    nixos.programs.gamescope.enable = mkEnableOption "Enables gamescope";
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
