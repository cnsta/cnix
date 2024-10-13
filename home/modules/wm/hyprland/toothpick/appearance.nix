{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.wm.hyprland.toothpick.appearance;
in {
  options = {
    userModules.wm.hyprland.toothpick.appearance.enable = mkEnableOption "Enables appearance settings in Hyprland";
  };
  config = mkIf cfg.enable {
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
          size = 8;
          passes = 1;
          vibrancy = 0.1696;
        };
        drop_shadow = false;
        shadow_range = 4;
        shadow_render_power = 3;
        #    col.shadow = rgba(1a1a1aee)
      };
      animations = {
        enabled = true;
        bezier = [
          "myBezier,0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 3, myBezier"
          "windowsOut, 1, 3, default, popin 80%"
          "border, 1, 3, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 3, default"
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
