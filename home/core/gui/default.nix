{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../extra/mako
    ./rofi
    ./waybar
    ./anyrun
    ./gtk
    ./xdg
  ];

  home.packages = with pkgs; [
    # APPLICATIONS
    ranger
    xfce.thunar

    # UTILITY
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    gnome.file-roller

    grimblast
    slurp
    hyprpicker
    pamixer
    pavucontrol
    fastfetch
    nwg-look
    thefuck
    wl-clipboard
    swaybg
    gnome.gnome-calculator
    gnome.adwaita-icon-theme
    oculante
    qt5.qtwayland
    qt6.qtwayland

    # NETWORK
    wireguard-tools
    networkmanagerapplet
    wpa_supplicant

    # SYSTEM
    btop
    htop
  ];
}
