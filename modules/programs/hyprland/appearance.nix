{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.hyprland;
in
{
  options.cnix.programs.hyprland.appearance.enable =
    mkEnableOption "Enables appearance settings in Hyprland";

  config = mkIf cfg.appearance.enable {
    programs.hyprland.settings = {
      general = {
        gaps_in = 2;
        gaps_out = "4, 4, 4, 4";
        border_size = 3;
        "col.active_border" = "rgb(4c7a5d)"; # rgba(b16286ee) 45deg
        "col.inactive_border" = "rgb(504945)";
        layout = "dwindle";
        resize_on_border = false;
      };
      decoration = {
        rounding = 0;
        blur = {
          enabled = true;
          brightness = 1.0;
          contrast = 1.0;
          noise = 0.0117;
          vibrancy = 0.15;
          vibrancy_darkness = 0.5;
          passes = 2;
          size = 12;
          popups = true;
          popups_ignorealpha = 0.2;
        };
        shadow = {
          enabled = false;
          color = "rgba(00000025)";
          offset = "0 5";
          range = 45;
          render_power = 2;
          scale = 0.95;
        };
      };
      animations.enabled = true;
      bezier = [
        "easeout,0.5, 1, 0.9, 1"
        "easeoutback,0.34,1.22,0.65,1"
      ];
      animation = [
        "border, 1, 2, default"
        "fade, 1, 4, default"
        "windowsOut,1,3,easeout,slide"
        "windowsMove,1,3,easeoutback"
        "windowsIn,1,3,easeoutback,slide"
        "workspaces, 1, 2, default, slide"
      ];
      dwindle = {
        preserve_split = true;
      };
    };
  };
}
