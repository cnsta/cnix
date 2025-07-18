{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.waybar;
  # uwsm = lib.getExe pkgs.uwsm;
  waybar = lib.getExe pkgs.waybar;

  waybarAssets = pkgs.runCommand "waybar-config-assets" {} ''
    mkdir -p $out/assets
    cp ${./assets/button.svg} $out/assets/button.svg
    cp ${./config/style.css} $out/style.css
    cp ${./config/config.jsonc} $out/config.jsonc
  '';
in {
  options = {
    home.programs.waybar.enable = mkEnableOption "Enables waybar";
  };
  config = mkIf cfg.enable {
    systemd.user.services.waybar = {
      Unit = {
        Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
        After = ["graphical-session.target"];
      };
      Service = {
        Type = "exec";
        ExecStart = "${waybar} -c ${waybarAssets}/config.jsonc -s ${waybarAssets}/style.css";
        Restart = "on-failure";
        Slice = "app-graphical.slice";
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
