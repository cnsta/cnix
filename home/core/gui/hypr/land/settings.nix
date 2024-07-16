{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-3,2560x1440@143.86,auto,1"
      "eDP-1,1920x1200@60.02,auto,1"
    ];
    general = {
      gaps_in = 2;
      gaps_out = 4;
      border_size = 3;
      #col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      #col.inactive_border = "rgba(595959aa)";
      col.active_border = "rgb(689d6a)"; # rgba(b16286ee) 45deg
      col.inactive_border = "rgb(504945)";
      layout = "dwindle";
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
      #    col.shadow = "rgba(1a1a1aee)";
    };

    animations = {
      enabled = true;
      bezier = ["myBezier, 0.05, 0.9, 0.1, 1.05"];
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

    input = {
      follow_mouse = 1;
      accel_profile = "flat";
      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
        natural_scroll = true;
        disable_while_typing = true;
        clickfinger_behavior = true;
        scroll_factor = 0.5;
      };
    };
    # Desktop keyboard
    device = {
      name = "pfu-limited-hhkb-hybrid";
      kb_layout = "hhkbse";
      kb_options = "lv3:rwin_switch";
    };
    device = {
      name = "hhkb-hybrid_1-keyboard";
      kb_layout = "hhkbse";
      kb_options = "lv3:rwin_switch";
    };
    # Laptop keyboard
    device = {
      name = "at-translated-set-2-keyboard";
      kb_layout = "se";
      kb_options = "ctrl:swapcaps";
    };
    gestures = {
      workspace_swipe = true;
      workspace_swipe_distance = 400;
      workspace_swipe_fingers = 3;
      workspace_swipe_cancel_ratio = 0.2;
      workspace_swipe_min_speed_to_force = 5;
      workspace_swipe_direction_lock = true;
      workspace_swipe_direction_lock_threshold = 10;
      workspace_swipe_create_new = true;
    };
    misc = {
      vrr = 2;
      mouse_move_enables_dpms = 1;
      key_press_enables_dpms = 0;
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };
  };
}
