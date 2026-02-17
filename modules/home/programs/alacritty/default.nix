{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs;
in
{
  options = {
    home.programs.alacritty.enable = mkEnableOption "Enables firefox";
  };
  config = mkIf cfg.alacritty.enable {
    programs.alacritty = {
      enable = true;
      theme = "afterglow";
      settings = {
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
          opacity = 0.95;
          padding = {
            x = 5;
            y = 5;
          };
          dimensions = {
            columns = 120;
            lines = 35;
          };
        };
        terminal.shell = mkIf cfg.fish.enable {
          program = "${pkgs.fish}/bin/fish";
        };
      };
    };
  };
}
