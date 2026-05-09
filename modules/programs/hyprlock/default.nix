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
    };
    animation = [
      "inputFieldDots, 1, 2, linear"
      "fadeIn, 0"
    ];
    background = [
      {
        monitor = "";
        path = bgs.resolve bg.lockscreen;
      }
    ];
    input-field = [
      {
        monitor = "";
        size = "200, 50";
        outline_thickness = 0;
        dots_size = 0.2;
        dots_spacing = 0.5;
        dots_center = true;
        dots_rounding = 0;
        outer_color = "rgba(0,0,0,0)";
        inner_color = "rgba(0,0,0,0)";
        font_color = "rgba(FFFFFFFF)";
        fade_on_empty = false;
        fade_timeout = 0;
        fail_text = "";
        placeholder_text = "";
        hide_input = false;
        rounding = 0;
        check_color = "rgba(0,0,0,0)";
        fail_color = "rgba(0,0,0,0)";
        position = "0, 20";
        halign = "center";
        valign = "center";
        font_family = "DepartureMono Nerd Font Mono Italic";
      }
    ];
    label = [
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
        text = "cmd[update:1000] echo '$TIME'";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = "rgba(FFFFFFFF)";
        font_size = 85;
        font_family = "VCR OSD Mono";
        position = "0, 300";
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
