{pkgs, ...}: {
  imports = [
    ./zellij
    ./firefox
    ./neovim
    ./lutris
  ];
  home.packages = with pkgs; [
    # APPLICATIONS
    alacritty
    keepassxc
    qbittorrent
    ranger
    webcord
    calcurse
    xfce.thunar

    # UTILITY
    wl-clipboard
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    gnome.file-roller
    pamixer
    pwvucontrol
    virt-manager
    fastfetch
    waybar
    nwg-look
    thefuck
    gnome.adwaita-icon-theme

    # NETWORK
    wireguard-tools
    networkmanagerapplet
    wpa_supplicant

    # SYSTEM
    kdePackages.polkit-kde-agent-1
    ntfs3g
    btop
    htop
  ];
}
