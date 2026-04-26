{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.home.programs.pkgs;
in
{
  options = {
    home.programs.pkgs = {
      common.enable = mkEnableOption "core packages";
      gui.enable = mkEnableOption "gui-specific packages";
      desktop.enable = mkEnableOption "desktop-specific packages";
      laptop.enable = mkEnableOption "laptop-specific packages";
      dev.enable = mkEnableOption "dev-specific packages";
    };
  };
  config = {
    home.packages =
      with pkgs;
      mkMerge [
        (mkIf cfg.common.enable [
          cmatrix
          xcur2png
          nix-tree
          exiftool
        ])

        (mkIf cfg.gui.enable [
          nwg-look
          gnome-calculator
          slurp
          grimblast
          tesseract
          hyprpicker
          loupe
          adwaita-icon-theme
          wl-screenrec
          wl-clipboard
          wayland-utils
          qt5.qtwayland
          qt6.qtwayland
          material-icons
          material-symbols
          feh
          feishin
          overskride
          hoppscotch
        ])

        (mkIf cfg.desktop.enable [
          protontricks
          monero-gui
        ])

        (mkIf cfg.laptop.enable [
        ])

        (mkIf cfg.dev.enable [
        ])
      ];
  };
}
