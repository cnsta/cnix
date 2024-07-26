{
  pkgs,
  inputs,
  ...
}: {
  programs.wezterm = {
    enable = true;
    package = inputs.wezterm.packages.${pkgs.system}.default;

    extraConfig = ''
      return {
          font = wezterm.font("Input Mono Compressed"),
          font_size = 12,
          check_for_updates = false,
          color_scheme = 'Gruvbox Material (Gogh)',
          default_cursor_style = 'SteadyBar',
          enable_scroll_bar = true,
          hide_tab_bar_if_only_one_tab = true,
          scrollback_lines = 10000,
          window_background_opacity = 0.9,
      }
    '';
  };
}
