{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.hyprland;
in {
  options = {
    home.programs.hyprland.appearance.enable = mkEnableOption "Enables appearance settings in Hyprland";
  };
  config = mkIf cfg.appearance.enable {
    wayland.windowManager.hyprland.settings = {
      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 3;
        #col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        #col.inactive_border = rgba(595959aa)
        "col.active_border" = "rgb(4c7a5d)"; # rgba(b16286ee) 45deg
        "col.inactive_border" = "rgb(504945)";
        layout = "dwindle";
        allow_tearing = false;
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
          passes = 2;
          size = 7;
          popups = true;
          popups_ignorealpha = 0.2;
        };
        shadow = {
          enabled = true;
          color = "rgba(00000025)";
          ignore_window = true;
          offset = "0 5";
          range = 45;
          render_power = 2;
          scale = 0.95;
        };
      };
      animations = {
        enabled = true;
        bezier = [
          "myBezier,0.19, 1, 0.22, 1"
        ];
        animation = [
          "windows, 1, 3, myBezier"
          "windowsOut, 1, 3, default, popin 80%"
          "border, 1, 2, default"
          "workspaces, 1, 2, default, slide"
          "specialWorkspace, 1, 2, default, fade"
        ];
      };
      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };
    };
  };
}
