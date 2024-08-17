{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.wm.hyprland.toothpick.keybinds;
in {
  options = {
    modules.wm.hyprland.toothpick.keybinds.enable = mkEnableOption "Enables keybind settings in Hyprland";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      "$terminal" = "foot";
      "$fileManager" = "thunar";
      "$passwordManager" = "keepassxc";
      "$menu" = "pkill anyrun || anyrun | xargs hyprctl dispatch exec --";
      "$menuw" = "pkill anyrun || anyrun | xargs hyprctl dispatch exec --";
      "$browser" = "firefox";
      "$browserinc" = "firefox --private-window";
      "$ranger" = "rangerscript";

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$mod" = "ALT_L";

      bind = let
        grimblast = lib.getExe pkgs.grimblast;
        tesseract = lib.getExe pkgs.tesseract;
        notify-send = lib.getExe' pkgs.libnotify "notify-send";
      in [
        # Custom binds
        "$mod SHIFT, B, exec, pkill -SIGUSR2 waybar" # Reload waybar

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mod, A, exec, pkill -SIGUSR1 waybar"
        "$mod, T, exec, $terminal"
        "$mod, W, exec, $browser"
        "$mod, K, exec, $passwordManager"
        "$mod SHIFT, W, exec, $browserinc"
        "$mod, Q, killactive,"
        #bind = $mod, M, exec, hyprctl dispatch exit
        #bind = $mod, E, exec, $fileManager
        "$mod, E, exec, $fileManager"
        "$mod SHIFT, E, exec, $ranger"
        "$mod, F, fullscreen,"
        "$mod SHIFT, F, togglefloating,"
        "$mod, SPACE, exec, $menu"
        "$mod, P, pseudo," # dwindle
        "$mod, J, togglesplit," # dwindle
        "$mod, C, exec, hyprctl dispatch exec copyq toggle"
        "$mod, TAB, exec, $menuw"

        # Move focus with mainMod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Laptop controls
        ",XF86AudioLowerVolume, exec, pamixer -d 5"
        ",XF86AudioRaiseVolume, exec, pamixer -i 5"
        ",XF86AudioMute, exec, pamixer -m"
        ",XF86AudioMicMute, exec, pactl -- set-source-mute 0 toggle"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ",XF86MonBrightnessUp, exec, brightnessctl s +10%"

        "$mod, XF86MonBrightnessUp, exec, hyprctl dispatch dpms on"
        "$mod, XF86MonBrightnessDown, exec, hyprctl dispatch dpms off"

        # Screenshotting
        ",Print,exec,${grimblast} --notify --freeze copysave area"
        "SHIFT,Print,exec,${grimblast} --notify --freeze copysave output"
        # To OCR
        "ALT,Print,exec,${grimblast} --freeze save area - | ${tesseract} - - | wl-copy && ${notify-send} -t 3000 'OCR result copied to buffer'"

        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        # bind = $mod, mouse_down, workspace, e+1
        # bind = $mod, mouse_up, workspace, e-1
      ];
      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
