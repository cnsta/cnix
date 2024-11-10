{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.misc;
in {
  options = {
    home.programs.misc.enable = mkEnableOption "Enables miscellaneous utility apps";
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
      # a monitor of resources
      btop = {
        enable = true;
        package = pkgs.btop.override {rocmSupport = true;};
        settings = {
          color_theme = "gruvbox_material_dark";
        };
      };
    };
    home.packages = with pkgs; [
      # misc.gui
      # virt-manager
      gnome-calculator
      keepassxc
      # networkmanagerapplet # tray icon for NetworkManager
      nwg-look # GTK settings
      pavucontrol # GUI sound control
      qbittorrent
      usbimager # write bootable usb images!
      slurp # select region for screenshot
      # misc.tui
      ranger
      xcur2png
      cmatrix
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
      unzip
      zip
      gnutar
      p7zip
    ];
  };
}
