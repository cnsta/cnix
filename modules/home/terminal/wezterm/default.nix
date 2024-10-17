{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  enable_wayland = "true";
  weztermPkg = pkgs.wezterm;
  # weztermFlake = inputs.wezterm.packages.${pkgs.system}.default;
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.terminal.wezterm;
in {
  options = {
    home.terminal.wezterm.enable = mkEnableOption "Enables wezterm terminal";
  };
  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      package = weztermPkg;
      extraConfig =
        /*
        lua
        */
        ''
                            local wezterm = require 'wezterm';

                            local config = {
                            -- font = wezterm.font("Input Mono Compressed"),
                            font_size = 12,
                            check_for_updates = false,
                            color_scheme = 'Gruvbox Material (Gogh)',
                            default_cursor_style = 'SteadyBar',
                               enable_scroll_bar = false,
                            enable_tab_bar = false,
          use_fancy_tab_bar = false,
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
  };
}
