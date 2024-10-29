{
  # inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.hyprlock;

  # hyprlockFlake = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
  hyprlockPkg = pkgs.hyprlock;
in {
  options = {
    home.programs.hyprlock.enable = mkEnableOption "Enables hyprlock";
  };
  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      package = hyprlockPkg;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
          no_fade_in = true;
          no_fade_out = true;
          ignore_empty_input = true;
          immediate_render = true;
        };
        background = [
          {
            monitor = "";
            path = "~/media/images/l_int06_big.jpg";
          }
        ];
        input-field = [
          {
            monitor = "";
            size = "200, 50";
            outline_thickness = 0;
            dots_size = 0.1;
            dots_spacing = 0.3;
            dots_center = true;
            dots_rounding = -1;
            outer_color = "rgba(0,0,0,0)";
            inner_color = "rgba(0,0,0,0)";
            font_color = "rgba(FFFFFFFF)";
            fade_on_empty = false;
            fade_timeout = 0;
            fail_text = "";
            fail_transition = 0;
            placeholder_text = "";
            hide_input = false;
            rounding = 0;
            check_color = "rgba(0,0,0,0)";
            fail_color = "rgba(0,0,0,0)";
            position = "0, 20";
            halign = "center";
            valign = "center";
          }
        ];
        label = [
          # date
          {
            monitor = "";
            text = "cmd[update:3600000] date +'%A, %B %d'";
            shadow_passes = 1;
            shadow_boost = 0.5;
            color = "rgba(FFFFFFFF)";
            font_size = 25;
            font_family = "Input Mono Compressed";
            position = "0, 230";
            halign = "center";
            valign = "center";
          }
          # clock
          {
            monitor = "";
            text = "cmd[update:1000] echo '$TIME'";
            shadow_passes = 1;
            shadow_boost = 0.5;
            color = "rgba(FFFFFFFF)";
            font_size = 85;
            font_family = "Input Mono Compressed";
            position = "0, 300";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
