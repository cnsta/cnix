{ lib
, config
, ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.wm.hyprland.toothpick.inputs;
in
{
  options = {
    modules.wm.hyprland.toothpick.inputs.enable = mkEnableOption "Enables input settings in Hyprland";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        "monitor=DVI-D-1,1920x1080@144,auto,1"
      ];
      env = [
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      ];

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
      device = [
        {
          name = "usb-hid-keyboard";
          kb_layout = "se";
        }
      ];
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
        vrr = 0;
        mouse_move_enables_dpms = 1;
        key_press_enables_dpms = 0;
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      xwayland = {
        force_zero_scaling = false;
      };
      render = {
        explicit_sync = 0;
        explicit_sync_kms = 0;
        direct_scanout = false;
      };
      cursor = {
        no_hardware_cursors = true;
        #     no_break_fs_vrr = true;
        #     min_refresh_rate = 60;
      };
    };
  };
}
