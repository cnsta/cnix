{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.waybar;
in {
  options = {
    home.programs.waybar.enable = mkEnableOption "Enables waybar";
  };
  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      systemd.enable = true;
    };

    systemd.user.services.waybar = {
      Unit.After = ["graphical-session.target"];
      Service.Slice = ["app-graphical.slice"];
      Unit.StartLimitBurst = 30;
    };
  };
}
