{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkMerge
    genAttrs
    ;
  cfg = config.cnix.programs.hyprland;
  host = config.networking.hostName;
  acct = config.cnix.settings.accounts;
in
{
  options.cnix.programs.hyprland.inputs.enable = mkEnableOption "Enables input settings in Hyprland";
  config = mkIf cfg.inputs.enable (mkMerge [
    {
      cnix.programs.hyprland.lua.configParts = [
        {
          input = {
            kb_layout = "se";
            kb_variant = "nodeadkeys";
            follow_mouse = 1;
            accel_profile = "flat";
            sensitivity = 0;
            touchpad = {
              natural_scroll = true;
              disable_while_typing = true;
              clickfinger_behavior = true;
              scroll_factor = 0.5;
            };
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
          xwayland.force_zero_scaling = false;
        }
      ];

      hjem.users = genAttrs acct.defaultUsers (_: {
        xdg.config.files."uwsm/env".text = ''
          export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
          export GRIMBLAST_NO_CURSOR=0
        '';
      });
    }

    (mkIf (host == "kima") {
      cnix.programs.hyprland.lua.configParts = [
        {
          render.direct_scanout = 0;
          cursor.no_hardware_cursors = 2;
          input.kb_options = "altwin:swap_lalt_lwin";
          general.allow_tearing = false;
          misc.vrr = 0;
        }
      ];
    })

    (mkIf (host == "bunk") {
      cnix.programs.hyprland.lua.configParts = [
        {
          input.kb_options = "ctrl:swapcaps,altwin:swap_lalt_lwin";
          general.allow_tearing = false;
          misc.vrr = 0;
        }
      ];
    })

    (mkIf (host == "toothpc") {
      cnix.programs.hyprland.lua.configParts = [
        {
          input.kb_options = "altwin:swap_lalt_lwin";
          render.direct_scanout = 0;
          cursor.no_hardware_cursors = true;
          general.allow_tearing = false;
          misc.vrr = 0;
        }
      ];
    })
  ]);
}
