{ config
, lib
, ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.terminal.kitty;
in
{
  options = {
    modules.terminal.kitty.enable = mkEnableOption "Enables kitty terminal";
  };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      settings = {
        # include = "theme.conf";
        enable_audio_bell = false;
        open_url_with = "firefox-nightly";
        font_family = "Input Mono Compressed Extra Light";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        font_size = "11.0";
        cursor_blink_interval = 0;
        copy_on_select = "clipboard";
        background_opacity = "0.95";
        background_blur = "32";
        window_padding_width = 3;
        # tab_bar_min_tabs = 1;
        # tab_bar_edge = "bottom";
        tab_bar_style = "separator";
        tab_bar_margin_width = "0.0";
        tab_bar_margin_height = "0.0 0.0";
        active_tab_font_style = "normal";
        inactive_tab_font_style = "normal";
        # tab_title_max_length = 30;
        # # colors
        # active_tab_foreground = "#32302f";
        # active_tab_background = "#282828";
        # inactive_tab_foreground = "#282828";
        # inactive_tab_background = "#504945";
        tab_bar_background = "#504945";
        tab_bar_min_tabs = 1;
        tab_bar_edge = "bottom";
        # tab_powerline_style = "slanted";
      };
      extraConfig = ''
        kitty_mod shift+ctrl
        map kitty_mod+q close_tab
        map ctrl+shift+c copy_to_clipboard
        map ctrl+shift+v paste_from_clipboard
        tab_separator ""
        tab_title_template        "{fmt.fg._504945}{fmt.bg.default}▓{fmt.fg._282828}{fmt.bg.default}{index}{fmt.fg._282828}{fmt.bg._504945} {title[:15] + (title[15:] and '…')} {fmt.fg._504945}{fmt.bg.default}▓ "
        active_tab_title_template "{fmt.fg._282828}{fmt.bg.default}▓{fmt.fg._A89984}{fmt.bg._282828}{fmt.fg._A89984}{fmt.bg._282828} {title[:40] + (title[40:] and '…')} {fmt.fg._282828}{fmt.bg.default}▓ "

        # vim:ft=kitty
        ## name: Gruvbox Material Dark Cnst
        ## author: Sainnhe Park
        ## license: MIT
        ## upstream: https://raw.githubusercontent.com/rsaihe/gruvbox-material-kitty/main/colors/gruvbox-material-dark-medium.conf
        ## blurb: A modified version of Gruvbox with softer contrasts

        background #282828
        foreground #d4be98

        selection_background #d4be98
        selection_foreground #282828

        cursor #a89984
        cursor_text_color background

        # Black
        color0 #665c54
        color8 #928374

        # Red
        color1 #ea6962
        color9 #ea6962

        # Green
        color2  #a9b665
        color10 #a9b665

        # Yellow
        color3  #e78a4e
        color11 #d8a657

        # Blue
        color4  #7daea3
        color12 #7daea3

        # Magenta
        color5  #d3869b
        color13 #d3869b

        # Cyan
        color6  #89b482
        color14 #89b482

        # White
        color7  #d4be98
        color15 #d4be98
      '';
    };
  };
}
