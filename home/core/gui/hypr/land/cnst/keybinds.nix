# KEYBINDS
{
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";
    "$fileManager" = "thunar";
    "$passwordManager" = "keepassxc";
    "$menu" = "pkill anyrun || anyrun | xargs hyprctl dispatch exec --";
    "$menuw" = "pkill anyrun || anyrun | xargs hyprctl dispatch exec --";
    "$browser" = "firefox-nightly";
    "$browserinc" = "firefox-nightly --private-window";
    "$ranger" = "rangerscript";

    # See https://wiki.hyprland.org/Configuring/Keywords/ for more
    "$mainMod" = "SUPER";

    bind = [
      # Custom binds
      "SUPER SHIFT, B, exec, pkill -SIGUSR2 waybar" # Reload waybar

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      "SUPER, A, exec, pkill -SIGUSR1 waybar"
      "SUPER, T, exec, $terminal"
      "SUPER, W, exec, $browser"
      "SUPER, K, exec, $passwordManager"
      "SUPER SHIFT, W, exec, $browserinc"
      "SUPER, Q, killactive,"
      #bind = SUPER, M, exec, hyprctl dispatch exit
      #bind = SUPER, E, exec, $fileManager
      "SUPER, E, exec, $fileManager"
      "SUPER SHIFT, E, exec, $ranger"
      "SUPER, F, fullscreen,"
      "SUPER SHIFT, F, togglefloating,"
      "SUPER, SPACE, exec, $menu"
      "SUPER, P, pseudo," # dwindle
      "SUPER, J, togglesplit," # dwindle
      "SUPER, C, exec, hyprctl dispatch exec copyq toggle"
      "SUPER, TAB, exec, $menuw"

      # Move focus with mainMod + arrow keys
      "SUPER, left, movefocus, l"
      "SUPER, right, movefocus, r"
      "SUPER, up, movefocus, u"
      "SUPER, down, movefocus, d"

      # Switch workspaces with mainMod + [0-9]
      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, 3, workspace, 3"
      "SUPER, 4, workspace, 4"
      "SUPER, 5, workspace, 5"
      "SUPER, 6, workspace, 6"
      "SUPER, 7, workspace, 7"
      "SUPER, 8, workspace, 8"
      "SUPER, 9, workspace, 9"
      "SUPER, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "SUPER SHIFT, 1, movetoworkspace, 1"
      "SUPER SHIFT, 2, movetoworkspace, 2"
      "SUPER SHIFT, 3, movetoworkspace, 3"
      "SUPER SHIFT, 4, movetoworkspace, 4"
      "SUPER SHIFT, 5, movetoworkspace, 5"
      "SUPER SHIFT, 6, movetoworkspace, 6"
      "SUPER SHIFT, 7, movetoworkspace, 7"
      "SUPER SHIFT, 8, movetoworkspace, 8"
      "SUPER SHIFT, 9, movetoworkspace, 9"
      "SUPER SHIFT, 0, movetoworkspace, 10"

      # Laptop controls
      ",XF86AudioLowerVolume, exec, pamixer -d 5"
      ",XF86AudioRaiseVolume, exec, pamixer -i 5"
      ",XF86AudioMute, exec, pamixer -m"
      ",XF86AudioMicMute, exec, pactl -- set-source-mute 0 toggle"
      ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ",XF86MonBrightnessUp, exec, brightnessctl s +10%"

      "SUPER, XF86MonBrightnessUp, exec, hyprctl dispatch dpms on"
      "SUPER, XF86MonBrightnessDown, exec, hyprctl dispatch dpms off"

      # Screenshot a window
      "SUPER, F10, exec, hyprshot -m window"
      # Screenshot a monitor
      ", F10, exec, hyprshot -m output"
      # Screenshot a region
      "SUPER SHIFT, F10, exec, hyprshot -m region"

      # Example special workspace (scratchpad)
      "SUPER, S, togglespecialworkspace, magic"
      "SUPER SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      # bind = SUPER, mouse_down, workspace, e+1
      # bind = SUPER, mouse_up, workspace, e-1
    ];
    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];
  };
}
