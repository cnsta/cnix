{
  pkgs,
  inputs,
  ...
}: let
  enable_wayland = "true";
  # weztermPkg = pkgs.wezterm;
  weztermFlake = inputs.wezterm.packages.${pkgs.system}.default;
in {
  programs.wezterm = {
    enable = true;
    package = weztermFlake;
    extraConfig = ''
                local wezterm = require 'wezterm';

                local config = {
                -- font = wezterm.font("Input Mono Compressed"),
                font_size = 12,
                check_for_updates = false,
                color_scheme = 'Gruvbox Material (Gogh)',
                default_cursor_style = 'SteadyBar',
                enable_scroll_bar = true,
                hide_tab_bar_if_only_one_tab = true,
                scrollback_lines = 10000,
                window_background_opacity = 0.9,
                }
                if wezterm.target_triple == "x86_64-pc-windows-msvc" then
                  config.default_prog = { "powershell.exe" }
                else
                  config.enable_wayland = ${enable_wayland}
                  -- config.window_decorations = "TITLE"
                  config.window_close_confirmation = "NeverPrompt"
                  -- config.freetype_load_target = "Light"
                  -- config.freetype_render_target = "HorizontalLcd"
                  local f = wezterm.font_with_fallback({
                    {family="Input Mono Compressed", weight="Light"},
                    {family="Input Sans Narrow", weight="Light"},
                  })
                  config.font = f;
                end
      return config
    '';
  };
}
