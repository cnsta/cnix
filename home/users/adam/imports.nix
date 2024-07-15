{pkgs, ...}: {
  imports = [
    # core.gui
    ../../core/gui/gtk
    ../../core/gui/waybar
    ../../core/gui/browsers
    ../../core/gui/xdg
    ../../core/gui/discord
    # core.tui
    ../../core/tui/git/adam.nix
    ../../core/tui/shell/adam.nix
    ../../core/tui/foot
    ../../core/tui/neovim
    # core.services
    ../../core/services/mako
    ../../core/services/polkit
    ../../core/services/hypr
  ];
  home = {
    packages = with pkgs; [
      # misc.gui
      file-roller
      gnome-calculator
      keepassxc
      nwg-look
      oculante
      pavucontrol
      qbittorrent
      virt-manager
      xfce.thunar

      # misc.tui
      alacritty
      btop
      calcurse
      fastfetch
      htop
      ranger

      # misc.system
      adwaita-icon-theme
      grimblast
      hyprpicker
      networkmanagerapplet
      pamixer
      qt5.qtwayland
      qt6.qtwayland
      slurp
      #  thefuck
      wireguard-tools
      wl-clipboard
      wpa_supplicant
      xfce.thunar-archive-plugin
      xfce.thunar-volman
    ];
    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      TERM = "foot";
    };
  };
}
