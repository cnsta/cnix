{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.hyprland.toothpick.inputs;
in {
  options = {
    home.programs.hyprland.toothpick.inputs.enable = mkEnableOption "Enables input settings in Hyprland";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      monitor = map (
        m: "${m.name},${
          if m.enabled
          then "${toString m.width}x${toString m.height}@${toString m.refreshRate},${m.position},1${
            if m.bitDepth != null
            then ",bitdepth,${toString m.bitDepth}"
            else ""
          }"
          else "disable"
        }"
      ) (config.monitors);
      workspace = map (
        m: "name:${m.workspace},monitor:${m.name}"
      ) (lib.filter (m: m.enabled && m.workspace != null) config.monitors);

      env = [
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
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
