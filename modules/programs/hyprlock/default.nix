{
  config,
  lib,
  bgs,
  clib,
  ...
}:
with lib; let
  cfg = config.cnix.programs.hyprlock;
  acct = config.cnix.settings.accounts;
  bg = config.cnix.settings.theme.background;

  settings = {
    general = {
      hide_cursor = false;
      ignore_empty_input = true;
      immediate_render = true;
      text_trim = true;
    };

    animations = {
      enabled = true;
      bezier = [
        "linear, 1, 1, 0, 0"
        "easeOutQuart, 0.25, 1.0, 0.5, 1.0"
        "easeInOut, 0.45, 0.0, 0.55, 1.0"
      ];
      animation = [
        "fadeIn, 1, 4, easeOutQuart"
        "fadeOut, 1, 4, easeOutQuart"
        "inputFieldDots, 1, 2, easeInOut"
        "inputFieldColors, 1, 3, easeInOut"
        "inputFieldWidth, 1, 4, easeOutQuart"
        "inputFieldFade, 1, 4, easeOutQuart"
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
        size = "300, 50";
        outline_thickness = 0;
        dots_size = 0.22;
        dots_spacing = 0.5;
        dots_center = true;
        dots_rounding = -1;

        outer_color = "rgba(FFFFFF15)";
        inner_color = "rgba(00000040)";
        font_color = "rgba(FFFFFFFF)";

        check_text = "<i>verifying…</i>";

        fail_color = "rgba(FF4D4DFF) rgba(C9184AFF) 45deg";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        swap_font_color = true;
        ignore_empty_input = true;
        fade_on_empty = false;
        fade_timeout = 0;
        placeholder_text = "<i> </i>";
        hide_input = false;
        rounding = 0;
        position = "0, 0";
        halign = "center";
        valign = "center";
        font_family = "IosevkaTermSlab Nerd Font Mono Italic";

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
        font_family = "IosevkaTermSlab Nerd Font Mono Light";
        position = "0, 220";
        halign = "center";
        valign = "center";
      }
      {
        monitor = "";
        text = "$TIME";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = "rgba(FFFFFFFF)";
        font_size = 80;
        font_family = "OverpassM Nerd Font Mono Light";
        position = "0, 300";
        halign = "center";
        valign = "center";
      }
    ];

    image = [
      {
        monitor = "";
        path = "/home/$USER/.face";
        size = 57;
        rounding = -1;
        position = "0, 80";
        halign = "center";
        valign = "center";
        border_size = 3;
      }
      {
        monitor = "";
        path = "/home/$USER/.os";
        size = 50;
        position = "-30, 30";
        halign = "right";
        valign = "bottom";
        border_size = 0;
      }
    ];
  };
in {
  options.cnix.programs.hyprlock.enable = mkEnableOption "hyprlock (Hyprland's lockscreen)";
  config = mkIf cfg.enable {
    programs.hyprlock.enable = true;
    hjem.users = genAttrs acct.defaultUsers (_: {
      files.".config/hypr/hyprlock.conf" = {
        text = clib.toHyprconf settings;
        clobber = true;
      };
    });
  };
}
