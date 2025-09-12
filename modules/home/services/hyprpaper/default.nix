{
  lib,
  pkgs,
  inputs,
  osConfig,
  cLib,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = osConfig.nixos.programs.hyprland;
  hyprpaperFlake = inputs.hyprpaper.packages.${pkgs.system}.default;
  bg = osConfig.settings.theme.background;
  bgs = cLib.theme.bgs;

  monitorMappings = [
    {
      monitor = "DP-3";
      bg = bg.primary;
    }
    {
      monitor = "HDMI-A-1";
      bg = bg.secondary;
    }
    {
      monitor = "eDP-1";
      bg = bg.primary;
    }
    {
      monitor = "DVI-D-1";
      bg = bg.primary;
    }
  ];
in
{
  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      package = hyprpaperFlake;

      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = bgs.all;
        wallpaper = bgs.resolveList monitorMappings;
      };
    };
  };
}
