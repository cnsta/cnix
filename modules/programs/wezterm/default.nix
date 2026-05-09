{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  enable_wayland = "true";
  # weztermPkg = pkgs.wezterm;
  weztermFlake = inputs.wezterm.packages.${pkgs.stdenv.hostPlatform.system}.default;
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.wezterm;
in
{
  options = {
    home.programs.wezterm.enable = mkEnableOption "Enables wezterm programs";
  };
  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      package = weztermFlake;
      extraConfig =
        # lua
        ''
          local wezterm = require 'wezterm'

          local config = {
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

          config.enable_wayland = ${enable_wayland}
          config.window_close_confirmation = "NeverPrompt"
          local f = wezterm.font_with_fallback({
            { family = "Input Mono Compressed", weight = "Light" },
            { family = "Input Sans Narrow", weight = "Light" },
          })
          config.font = f

          return config
        '';
    };
  };
}
