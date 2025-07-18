{
  config,
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.services.hyprpaper;

  hyprpaperFlake = inputs.hyprpaper.packages.${pkgs.system}.default;
  # hyprpaperPkg = pkgs.hyprpaper;
in {
  options = {
    home.services.hyprpaper.enable = mkEnableOption "Enables hyprpaper";
  };
  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      package = hyprpaperFlake;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = [
          "~/media/images/bg_1.jpg"
          "~/media/images/bg_2.jpg"
          "~/media/images/bg_3.jpg"
          "~/media/images/by_housevisit_2560.jpg"
          "~/media/images/nix.png"
          "~/media/images/stacks.png"
          "~/media/images/ship.png"
          "~/media/images/cabin.png"
          "~/media/images/dunes.png"
          "~/media/images/globe.png"
          "~/media/images/space.jpg"
          "~/media/images/galaxy.png"
          "~/media/images/deathstar.png"
          "~/media/images/trollskog.png"
        ];

        wallpaper = [
          # kima
          "DP-3,${osConfig.theme.background.desktop}"
          "HDMI-A-1,${osConfig.theme.background.lockscreen}"
          # bunk
          "eDP-1,${osConfig.theme.background.desktop}"
          # toothpc
          "DVI-D-1,${osConfig.theme.background.desktop}"
        ];
      };
    };
  };
}
