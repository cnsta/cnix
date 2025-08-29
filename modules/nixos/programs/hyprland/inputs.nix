{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.nixos.programs.hyprland;
  host = config.networking.hostName;
in
{
  options = {
    nixos.programs.hyprland.inputs.enable = mkEnableOption "Enables input settings in Hyprland";
  };
  config = mkIf cfg.inputs.enable (mkMerge [
    {
      programs.hyprland.settings = {
        env = [
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          # See https://github.com/hyprwm/contrib/issues/142
          "GRIMBLAST_NO_CURSOR,0"
        ];

        input = {
          kb_layout = "se";
          kb_variant = "nodeadkeys";
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
          mouse_move_enables_dpms = 1;
          key_press_enables_dpms = 0;
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          disable_autoreload = true;
          disable_xdg_env_checks = true;
          layers_hog_keyboard_focus = false;
        };

        xwayland = {
          force_zero_scaling = false;
        };
      };
    }

    (mkIf (host == "kima") {
      programs.hyprland.settings = {
        render = {
          direct_scanout = 1;
        };
        cursor = {
          no_hardware_cursors = 2;
        };
        general = {
          allow_tearing = false;
        };
        misc = {
          vrr = 0;
          vfr = true;
        };
      };
    })

    (mkIf (host == "bunk") {
      programs.hyprland.settings = {
        input = {
          kb_options = "ctrl:swapcaps";
        };
        general = {
          allow_tearing = false;
        };
        misc = {
          vrr = 0;
          vfr = true;
        };
      };
    })

    (mkIf (host == "toothpc") {
      programs.hyprland.settings = {
        render = {
          direct_scanout = 0;
        };
        cursor = {
          no_hardware_cursors = true;
        };
        general = {
          allow_tearing = false;
        };
        misc = {
          vrr = 0;
        };
      };
    })
  ]);
}
