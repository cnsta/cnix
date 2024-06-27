{ pkgs, ... }:
{
  imports = [
    ./zellij
    ./firefox
    ./git
    ./hypr
    ./neovim
    ./shell/adam.nix
    ./appearance
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
    qbittorrent
    fastfetch
    waybar
    nwg-look
    thefuck
    calcurse
    gnome.adwaita-icon-theme
  ];
}
