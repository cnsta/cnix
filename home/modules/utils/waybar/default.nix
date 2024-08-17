{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.waybar;
in {
  options = {
    modules.utils.waybar.enable = mkEnableOption "Enables waybar";
  };
  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
    };
  };
}
