{
  config,
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.home.services.hyprpaper;

  hyprpaperFlake = inputs.hyprpaper.packages.${pkgs.system}.default;

  bgs = {
    wallpaper_1 = "~/media/images/bg_1.jpg";
    wallpaper_2 = "~/media/images/bg_2.jpg";
    wallpaper_3 = "~/media/images/bg_3.jpg";
    wallpaper_4 = "~/media/images/waterwindow.jpg";
    wallpaper_5 = "~/media/images/barngreet.png";
  };

  resolve = name: if name == null then null else bgs.${name};
  bg = osConfig.settings.theme.background;

  wallpapers = builtins.filter (x: x != null) [
    "DP-3,${resolve bg.primary}"
    (if bg.secondary != null then "HDMI-A-1,${resolve bg.secondary}" else null)
    "eDP-1,${resolve bg.primary}"
    "DVI-D-1,${resolve bg.primary}"
  ];
in
{
  options = {
    home.services.hyprpaper.enable = mkEnableOption "Enable hyprpaper wallpaper service";
  };

  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      package = hyprpaperFlake;

      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = builtins.attrValues bgs;

        wallpaper = wallpapers;
      };
    };
  };
}
