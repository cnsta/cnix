{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.hyprland;
in
{
  options = {
    nixos.programs.hyprland.appearance.enable =
      mkEnableOption "Enables appearance settings in Hyprland";
  };
  config = mkIf cfg.appearance.enable {
    programs.hyprland.settings = {
      general = {
        gaps_in = 2;
        gaps_out = "4, 4, 4, 4";
        border_size = 3;
        #col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        #col.inactive_border = rgba(595959aa)
        "col.active_border" = "rgb(4c7a5d)"; # rgba(b16286ee) 45deg
        "col.inactive_border" = "rgb(504945)";
        layout = "dwindle";
        resize_on_border = true;
      };
      decoration = {
        rounding = 0;
        blur = {
          enabled = true;
          brightness = 1.0;
          contrast = 1.0;
          noise = 0.01;
          vibrancy = 0.15;
          vibrancy_darkness = 0.5;
          passes = 1;
          size = 3;
          popups = true;
          popups_ignorealpha = 0.2;
        };
        shadow = {
          enabled = false;
          color = "rgba(00000025)";
          ignore_window = true;
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
        # "windows, 1, 2.5, default"
        "workspaces, 1, 2, default, slide"
      ];
      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };
    };
  };
}
