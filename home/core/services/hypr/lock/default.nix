{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = false;
        no_fade_in = false;
      };
      background = [
        {
          color = "rgba(000000FF)";
          monitor = "";
          path = "~/media/images/wallpaper.png";
          blur_size = 3;
          blur_passes = 2;
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "200, 50";
          outline_thickness = 2;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgba(3B3B3B55)";
          inner_color = "rgba(33333311)";
          font_color = "rgba(FFFFFFFF)";
          fade_on_empty = true;
          fade_timeout = 5000;
          placeholder_text = "";
          hide_input = false;
          rounding = -1;
          check_color = "rgb(204, 136, 34)";
          fail_color = "rgb(204, 34, 34)";
        }
      ];
      label = [
        {
          # Clock
          monitor = "";
          text = "cmd[update:1000] echo '$TIME'";
          shadow_passes = 1;
          shadow_boost = 0.5;
          color = "rgba(FFFFFFFF)";
          font_size = 85;
          font_family = "Input Mono";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        # {
        #   # Date
        #   monitor = "";
        #   text = "cmd[update:1000] echo '$(date -I)'";
        #   shadow_passes = 1;
        #   shadow_boost = 0.5;
        #   color = "rgba(FFFFFFFF)";
        #   font_size = 25;
        #   font_family = "Input Mono Compressed";
        #
        #   position = "0, 280";
        #   halign = "center";
        #   valign = "center";
        # }
      ];
    };
  };
}
