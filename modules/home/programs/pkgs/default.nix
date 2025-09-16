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
      server.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install server-specific packages.";
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
          ripgrep
          file
          fd
          gnused
          nix-tree
          wireguard-tools
          unzip
          zip
          gnutar
          p7zip
        ]

        (mkIf cfg.common.enable [
          keepassxc
          usbimager
          nwg-look
          pavucontrol
          gnome-calculator
          slurp
          grimblast
          tesseract
          calcurse
          exiftool
          hyprpicker
          libnotify
          pamixer
          oculante
          adwaita-icon-theme
          qt5.qtwayland
          qt6.qtwayland
          wpa_supplicant
          unrar
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

        (mkIf cfg.server.enable [
        ])

        (mkIf cfg.dev.enable [
        ])
      ];
  };
}
