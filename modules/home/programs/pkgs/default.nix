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
      common.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install common packages.";
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
          wireguard-tools
        ]

        (mkIf cfg.common.enable [
          usbimager
          nwg-look
          gnome-calculator
          slurp
          grimblast
          tesseract
          exiftool
          hyprpicker
          loupe
          adwaita-icon-theme
          qt5.qtwayland
          qt6.qtwayland
          wpa_supplicant
          material-icons
          material-symbols
          feh
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
