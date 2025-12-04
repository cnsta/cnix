{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.nixos.programs.hyprland;
  host = config.networking.hostName;

  toggle =
    program:
    let
      prog = builtins.substring 0 14 program;
    in
    "pkill ${prog} || uwsm-app -- ${program}";

  runOnce = program: "pgrep ${program} || uwsm-app -- ${program}";
in
{
  options = {
    nixos.programs.hyprland.keybinds.enable = mkEnableOption "Enables keybind settings in Hyprland";
  };

  config = mkIf cfg.keybinds.enable (mkMerge [
    {
      programs.hyprland.settings = {
        # Common Keybind Variables
        "$fileManager" = "nautilus";
        "$yazi" = "foot -e yazi";
        "$launcher" = "fuzzel";

        bind = [
          "$mod, SPACE, exec, ${toggle "$launcher"}"
          "$mod, R, exec, ${toggle "$launcher"}"
          "$mod, Escape, exec, ${toggle "nwg-bar"}"
          "$mod, L, exec, loginctl lock-session"
          "$mod SHIFT, B, exec, pkill -SIGUSR2 waybar"
          "$mod, A, exec, pkill -SIGUSR1 waybar"
          "$mod, T, exec, uwsm-app -- $terminal"
          "$mod, W, exec, uwsm-app -- $browser"
          "$mod SHIFT, W, exec, uwsm-app -- $browserinc"
          "$mod, K, exec, keepassxc"
          "$mod, N, exec, ${toggle "swaync-client -t -sw"}"
          "$mod, O, exec, uwsm-app -- networkmanager_dmenu"
          "$mod, I, exec, uwsm-app -- alacritty -T 'VPN Switcher' -e vpnswitcher.sh"
          "$mod, Q, killactive,"
          "$mod, E, exec, uwsm-app -- $fileManager"
          "$mod SHIFT, E, exec, uwsm-app -- $yazi"
          "$mod, F, fullscreen,"
          "$mod SHIFT, F, togglefloating,"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"
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
          "CTRL SHIFT, Escape, exec, ${runOnce "resources"}"

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

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod SHIFT, left, resizeactive, -20 0"
          "$mod SHIFT, right, resizeactive, 20 0"
          "$mod SHIFT, up, resizeactive, 0 -20"
          "$mod SHIFT, down, resizeactive, 0 20"
          "$mod CTRL, left, swapwindow, l"
          "$mod CTRL, right, swapwindow, r"
          "$mod CTRL, up, swapwindow, u"
          "$mod CTRL, down, swapwindow, d"

          ",XF86AudioLowerVolume, exec, ${runOnce "volume-control.sh --dec"}"
          ",XF86AudioRaiseVolume, exec, ${runOnce "volume-control.sh --inc"}"
          ",XF86AudioMute, exec, ${runOnce "volume-control.sh --toggle"}"
          ",XF86AudioMicMute, exec, ${runOnce "volume-control.sh --toggle-mic"}"

          ",XF86MonBrightnessDown, exec, ${runOnce "brightnessctl s 5%-"}"
          ",XF86MonBrightnessUp, exec, ${runOnce "brightnessctl s +5%"}"
          "$mod, XF86MonBrightnessUp, exec, hyprctl dispatch dpms on"
          "$mod, XF86MonBrightnessDown, exec, hyprctl dispatch dpms off"

          ",Insert, exec, ${runOnce "grimblast"} --notify --freeze copysave area"
          "SHIFT, Insert, exec, ${runOnce "grimblast"} --notify --freeze copysave output"
          "ALT, Insert, exec, ${runOnce "grimblast"} --freeze save area - | ${runOnce "tesseract"} - - | wl-copy && ${runOnce "notify-send"} -t 3000 'OCR result copied to buffer'"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    }

    (mkIf (host == "kima") {
      programs.hyprland.settings = {
        "$terminal" = "alacritty";
        "$browser" = "firefox";
        "$browserinc" = "firefox --private-window";
        "$mod" = "SUPER";
        bind = [
          # Add more host-specific binds as needed
        ];
      };
    })

    (mkIf (host == "bunk") {
      programs.hyprland.settings = {
        "$terminal" = "alacritty";
        "$browser" = "firefox";
        "$browserinc" = "firefox --private-window";
        "$mod" = "ALT_L";
        bind = [
          # Add more host-specific binds as needed
        ];
      };
    })

    (mkIf (host == "toothpc") {
      programs.hyprland.settings = {
        "$terminal" = "alacritty";
        "$browser" = "firefox";
        "$browserinc" = "firefox --private-window";
        "$mod" = "ALT_L";
        bind = [
          # Add more host-specific binds as needed
        ];
      };
    })
  ]);
}
