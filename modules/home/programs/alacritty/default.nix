{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.alacritty;
in
{
  options = {
    home.programs.alacritty.enable = mkEnableOption "Enables firefox";
  };
  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      theme = "dark_plus";
      settings = {
        # Default colors
        # colors = {
        #   primary = {
        #     background = "#282828";
        #     foreground = "#d4be98";
        #   };
        #   # Normal colors
        #   normal = {
        #     black = "#3c3836";
        #     red = "#ea6962";
        #     green = "#a9b665";
        #     yellow = "#d8a657";
        #     blue = "#7daea3";
        #     magenta = "#d3869b";
        #     cyan = "#89b482";
        #     white = "#d4be98";
        #   };
        #   # Bright colors (same as normal colors)
        #   bright = {
        #     black = "#3c3836";
        #     red = "#ea6962";
        #     green = "#a9b665";
        #     yellow = "#d8a657";
        #     blue = "#7daea3";
        #     magenta = "#d3869b";
        #     cyan = "#89b482";
        #     white = "#d4be98";
        #   };
        # };
        font = {
          size = 12;
          normal = {
            family = "Input Mono Compressed";
            style = "Light";
          };
          bold = {
            family = "Input Mono Compressed";
            style = "Regular";
          };
          italic = {
            family = "Input Mono Compressed";
            style = "Italic";
          };
        };
        keyboard.bindings = [
          {
            action = "Copy";
            key = "C";
            mods = "Command";
          }
          {
            action = "Paste";
            key = "V";
            mods = "Command";
          }
        ];
        window = {
          dynamic_title = true;
          opacity = 0.9;
          padding = {
            x = 5;
            y = 5;
          };
          dimensions = {
            columns = 120;
            lines = 35;
          };
        };
      };
    };
  };
}
