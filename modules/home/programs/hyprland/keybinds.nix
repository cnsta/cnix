{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.home.programs.hyprland;
in {
  options = {
    home.programs.hyprland.keybinds.enable = mkEnableOption "Enables keybind settings in Hyprland";
  };

  config = mkIf cfg.keybinds.enable (mkMerge [
    {
      wayland.windowManager.hyprland.settings = {
        # Common Keybind Variables
        "$fileManager" = "thunar";
        "$passwordManager" = "keepassxc";
        "$menu" = "pkill anyrun || anyrun | xargs hyprctl dispatch exec --";
        "$menuw" = "pkill anyrun || anyrun | xargs hyprctl dispatch exec --";
        "$yazi" = "alacritty -e yazi";
        "$tuirun" = "tuirun-toggle.sh";

        bind = [
          "$mod SHIFT, B, exec, pkill -SIGUSR2 waybar"
          "$mod, A, exec, pkill -SIGUSR1 waybar"
          "$mod, T, exec, $terminal"
          "$mod, W, exec, $browser"
          "$mod, K, exec, $passwordManager"
          "$mod SHIFT, W, exec, $browserinc"
          "$mod, Q, killactive,"
          "$mod, E, exec, $fileManager"
          "$mod, R, exec, $tuirun"
          "$mod SHIFT, E, exec, $yazi"
          "$mod, F, fullscreen,"
          "$mod SHIFT, F, togglefloating,"
          "$mod, SPACE, exec, $tuirun"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"
          "$mod, C, exec, hyprctl dispatch exec copyq toggle"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
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
          ",XF86AudioLowerVolume, exec, pamixer -d 5"
          ",XF86AudioRaiseVolume, exec, pamixer -i 5"
          ",XF86AudioMute, exec, pamixer -t"
          ",XF86AudioMicMute, exec, pactl -- set-source-mute 0 toggle"
          ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
          ",XF86MonBrightnessUp, exec, brightnessctl s +5%"
          "$mod, XF86MonBrightnessUp, exec, hyprctl dispatch dpms on"
          "$mod, XF86MonBrightnessDown, exec, hyprctl dispatch dpms off"
          ",Insert,exec,${lib.getExe pkgs.grimblast} --notify --freeze copysave area"
          "SHIFT,Insert,exec,${lib.getExe pkgs.grimblast} --notify --freeze copysave output"
          "ALT,Insert,exec,${lib.getExe pkgs.grimblast} --freeze save area - | ${lib.getExe pkgs.tesseract} - - | wl-copy && ${lib.getExe pkgs.libnotify}/bin/notify-send -t 3000 'OCR result copied to buffer'"
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    }

    (mkIf (cfg.user == "cnst") {
      wayland.windowManager.hyprland.settings = let
        cnixpad = osConfig.networking.hostName == "cnixpad";
        modKey =
          if cnixpad
          then "ALT_L"
          else "SUPER";
      in {
        "$terminal" = "alacritty";
        "$browser" = "zen";
        "$browserinc" = "zen --private-window";
        "$mod" = modKey;
        bind = [
          # Add more host-specific binds as needed
        ];
      };
    })

    (mkIf (cfg.user == "toothpick") {
      wayland.windowManager.hyprland.settings = {
        "$terminal" = "foot";
        "$browser" = "firefox";
        "$browserinc" = "firefox --private-window";
        "$mod" = "ALT_L";
        bind = [
          # Add more toothpc-specific binds as needed
        ];
      };
    })
  ]);
}
