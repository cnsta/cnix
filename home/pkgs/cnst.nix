{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Desktop
    alacritty
    wl-clipboard
    dunst
    keepassxc
    ranger
    webcord
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    gnome.file-roller
    swaybg
    wireguard-tools
    wpa_supplicant
    ntfs3g
    kdePackages.polkit-kde-agent-1
    networkmanagerapplet
    blueman
    htop
    btop
    tofi
    pamixer
    virt-manager
    qbittorrent
    fastfetch
    waybar
    nwg-look
    mullvad-vpn
    thefuck
    calcurse
    gnome.adwaita-icon-theme
  ];
}
