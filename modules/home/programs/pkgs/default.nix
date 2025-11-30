{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    mkMerge
    ;
  cfg = config.home.programs.pkgs;
in
{
  options = {
    home.programs.pkgs = {
      enable = mkEnableOption "Enables miscellaneous utility apps";
      gui.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install gui-specific packages.";
      };
      desktop.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install desktop-specific packages.";
      };
      laptop.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install laptop-specific packages.";
      };
      dev.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install development-specific packages.";
      };
    };
  };
  config = mkIf cfg.enable {
    programs = {
      btop = {
        enable = true;
        package = pkgs.btop.override { rocmSupport = true; };
        settings = {
          color_theme = "gruvbox_material_dark";
        };
      };
    };

    home.packages =
      with pkgs;
      mkMerge [
        [
          cmatrix
          xcur2png
          nix-tree
          exiftool
        ]

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
          finamp
        ])

        (mkIf cfg.desktop.enable [
          protontricks
          monero-gui
          lutris
        ])

        (mkIf cfg.laptop.enable [
        ])

        (mkIf cfg.dev.enable [
        ])
      ];
  };
}
