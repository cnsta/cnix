{
  lib,
  osConfig,
  bgs,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = osConfig.nixos.programs.hyprland;
  bg = osConfig.settings.theme.background;

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
    home.packages = [ inputs.dotfiles.packages.${pkgs.stdenv.hostPlatform.system}.wppick ];
    services.hyprpaper = {
      enable = true;

      settings = {
        ipc = "on";
        splash = false;

        preload = bgs.all;
        wallpaper = bgs.resolveWallpaperBlocks monitorMappings;
      };
    };
  };
}
