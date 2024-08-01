{
  programs.kitty = {
    enable = true;
    theme = "Gruvbox Material Dark Soft";
    settings = {
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
      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "separator";
      tab_bar_margin_width = "0.0";
      tab_bar_margin_height = "0.0 0.0";
      active_tab_font_style = "bold";
      tab_title_max_length = 30;
      # colors
      active_tab_foreground = "#32302f";
      active_tab_background = "#A89984";
      inactive_tab_foreground = "#665C54";
      inactive_tab_background = "#373432";
      tab_bar_background = "#504945";
    };
    extraConfig = ''
      kitty_mod shift+ctrl
      map kitty_mod+q close_tab
      map ctrl+shift+c copy_to_clipboard
      map ctrl+shift+v paste_from_clipboard
      tab_separator " | "
      tab_title_template "{fmt.fg.tab}{title[:30]}"
    '';
  };
}
