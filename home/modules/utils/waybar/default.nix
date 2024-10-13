{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.utils.waybar;
in {
  options = {
    userModules.utils.waybar.enable = mkEnableOption "Enables waybar";
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
