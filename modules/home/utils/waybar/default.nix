{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.utils.waybar;
in {
  options = {
    home.utils.waybar.enable = mkEnableOption "Enables waybar";
  };
  config = mkIf cfg.enable {
    systemd.user.services.waybar = {
      Unit.StartLimitBurst = 30;
    };
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      systemd.enable = true;
    };
  };
}
