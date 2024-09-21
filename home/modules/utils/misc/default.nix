{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.misc;
in {
  options = {
    modules.utils.misc.enable = mkEnableOption "Enables miscellaneous utility apps";
  };
  config = mkIf cfg.enable {
    programs = {
      ssh = {
        enable = true;
      };
      # image viewer
      feh = {
        enable = true;
      };
      # system information
      fastfetch = {
        enable = true;
      };
      # a monitor of resources
      btop = {
        enable = true;
        settings = {
          color_theme = "gruvbox_material_dark";
        };
      };
    };
    home.packages = with pkgs; [
      # misc.gui
      virt-manager
      xfce.thunar
      file-roller # archiver
      gnome-calculator
      keepassxc
      networkmanagerapplet # tray icon for NetworkManager
      nwg-look # GTK settings
      pavucontrol # GUI sound control
      qbittorrent
      usbimager # write bootable usb images!
      slurp # select region for screenshot
      # misc.tui
      ranger
      xcur2png
      calcurse # calendar
      chatgpt-cli
      exiftool
      hyprpicker # Color picker
      libnotify
      pamixer # TUI sound control
      ripgrep
      file
      fd
      gnused
      nix-tree
      # misc.system
      adwaita-icon-theme
      qt5.qtwayland
      qt6.qtwayland
      wireguard-tools
      wl-clipboard
      wpa_supplicant
      xfce.thunar-archive-plugin
      xfce.thunar-volman
      unzip
      zip
      gnutar
      p7zip
    ];
  };
}
