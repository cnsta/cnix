{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.wm.utils.hyprpaper;

  hyprpaperFlake = inputs.hyprpaper.packages.${pkgs.system}.default;
  # hyprpaperPkg = pkgs.hyprpaper;
in {
  options = {
    home.wm.utils.hyprpaper.enable = mkEnableOption "Enables hyprpaper";
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
          "~/media/images/l_ash08_big.jpg"
          "~/media/images/l_ash09_big.jpg"
          "~/media/images/l_int06_big.jpg"
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
          # cnix
          "DP-3,~/media/images/l_ash08_big.jpg"
          # adampad
          "eDP-1,~/media/images/l_ash08_big.jpg"
          # toothpc
          "DVI-D-1,~/media/images/dunes.png"
          # "DP-1,/share/wallpapers/cat_pacman.png"
        ];
      };
    };
  };
}
