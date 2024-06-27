{ pkgs, ... }:
{
  imports = [
    ./firefox
    ./mako
    ./neovim
    ./zellij
  ];
  home.packages = with pkgs; [
    # Desktop
    alacritty
    wl-clipboard
    keepassxc
    ranger
    webcord
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    gnome.file-roller
    wireguard-tools
    wpa_supplicant
    ntfs3g
    kdePackages.polkit-kde-agent-1
    networkmanagerapplet
    htop
    btop
    pamixer
    virt-manager
    qbittorrent
    fastfetch
    waybar
    nwg-look
    thefuck
    calcurse
    gnome.adwaita-icon-theme
  ];
}
