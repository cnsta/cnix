{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.hyprland;
in {
  options.cnix.programs.hyprland.appearance.enable =
    mkEnableOption "Enables appearance settings in Hyprland";
  config = mkIf cfg.appearance.enable {
    cnix.programs.hyprland.lua = {
      configParts = [
        {
          general = {
            gaps_in = 2;
            gaps_out = 4;
            border_size = 3;
            col = {
              active_border = "rgb(4c7a5d)";
              inactive_border = "rgb(504945)";
            };
            layout = "dwindle";
            resize_on_border = false;
          };
          decoration = {
            rounding = 0;
            blur = {
              enabled = true;
              brightness = 1.0;
              contrast = 1.0;
              noise = 0.0117;
              vibrancy = 0.15;
              vibrancy_darkness = 0.5;
              passes = 2;
              size = 12;
              popups = true;
              popups_ignorealpha = 0.2;
            };
            shadow = {
              enabled = false;
              color = "rgba(00000025)";
              offset = "0 5";
              range = 45;
              render_power = 2;
              scale = 0.95;
            };
          };
          animations.enabled = true;
          dwindle.preserve_split = true;
        }
      ];

      curves = [
        {
          name = "easeout";
          points = [
            [
              0.5
              1
            ]
            [
              0.9
              1
            ]
          ];
        }
        {
          name = "easeoutback";
          points = [
            [
              0.34
              1.22
            ]
            [
              0.65
              1
            ]
          ];
        }
      ];

      animations = [
        {
          leaf = "border";
          enabled = true;
          speed = 2;
          bezier = "default";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 4;
          bezier = "default";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 3;
          bezier = "easeout";
          style = "slide";
        }
        {
          leaf = "windowsMove";
          enabled = true;
          speed = 3;
          bezier = "easeoutback";
        }
        {
          leaf = "windowsIn";
          enabled = true;
          speed = 3;
          bezier = "easeoutback";
          style = "slide";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 2;
          bezier = "default";
          style = "slide";
        }
      ];
    };
  };
}
