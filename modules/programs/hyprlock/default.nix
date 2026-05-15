{
  config,
  lib,
  bgs,
  clib,
  ...
}:
with lib;
let
  cfg = config.cnix.programs.hyprlock;
  acct = config.cnix.settings.accounts;
  bg = config.cnix.settings.theme.background;

  settings = {
    general = {
      hide_cursor = true;
      ignore_empty_input = true;
      immediate_render = true;
      text_trim = false;
    };

    animations = {
      enabled = true;
      bezier = [
        "linear,       1.0, 1.0, 0.0, 0.0"
        "easeOutQuart, 0.25, 1.0, 0.5, 1.0"
        "easeInOut,    0.45, 0.0, 0.55, 1.0"
      ];

      animation = [
        "fadeIn,           1, 4, easeOutQuart"
        "fadeOut,          1, 4, easeOutQuart"
        "inputFieldDots,   1, 2, easeInOut"
        "inputFieldColors, 1, 3, easeInOut"
        "inputFieldWidth,  1, 4, easeOutQuart"
        "inputFieldFade,   1, 4, easeOutQuart"
      ];
    };

    background = [
      {
        monitor = "";
        path = bgs.resolve bg.lockscreen;
      }
    ];

    input-field = [
      {
        monitor = "";
        size = "260, 55";
        outline_thickness = 2;
        dots_size = 0.22;
        dots_spacing = 0.5;
        dots_center = true;
        dots_rounding = -1;

        outer_color = "rgba(FFFFFF15)";
        inner_color = "rgba(00000040)";
        font_color = "rgba(FFFFFFFF)";

        # While PAM is checking
        check_color = "rgba(FFD479FF) rgba(FFAF40FF) 45deg";
        check_text = "<i>verifying…</i>";

        fail_color = "rgba(FF4D4DFF) rgba(C9184AFF) 45deg";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        fail_transition = 300;
        swap_font_color = true;

        fade_on_empty = false;
        fade_timeout = 0;
        placeholder_text = "";
        hide_input = false;
        rounding = 0;
        position = "0, 20";
        halign = "center";
        valign = "center";
        font_family = "DepartureMono Nerd Font Mono Italic";

        shadow_size = 4;
        shadow_passes = 2;
        shadow_color = "rgba(00000088)";
      }
    ];

    label = [
      # Date
      {
        monitor = "";
        text = "cmd[update:3600000] date +'%A, %B %d'";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = "rgba(FFFFFFFF)";
        font_size = 25;
        font_family = "VCR OSD Mono";
        position = "0, 230";
        halign = "center";
        valign = "center";
      }
      {
        monitor = "";
        text = "$TIME";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = "rgba(FFFFFFFF)";
        font_size = 85;
        font_family = "VCR OSD Mono";
        position = "0, 300";
        halign = "center";
        valign = "center";
      }
      {
        monitor = "";
        text = "$ATTEMPTS[]";
        color = "rgba(FF4D4DFF)";
        font_size = 14;
        font_family = "DepartureMono Nerd Font Mono Italic";
        position = "0, -40";
        halign = "center";
        valign = "center";
      }
    ];
  };
in
{
  options.cnix.programs.hyprlock.enable = mkEnableOption "hyprlock (Hyprland's lockscreen)";
  config = mkIf cfg.enable {
    programs.hyprlock.enable = true;
    hjem.users = genAttrs acct.defaultUsers (_: {
      xdg.config.files."hypr/hyprlock.conf".text = clib.toHyprconf settings;
    });
  };
}
