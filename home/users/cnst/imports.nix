{pkgs, ...}: {
  imports = [
    # core.gui
    ../../core/gui/gtk
    ../../core/gui/mako
    ../../core/gui/waybar
    ../../core/gui/xdg
    # core.tui
    ../../core/tui/git/cnst.nix
    ../../core/tui/shell/cnst.nix
    # core.system
    ../../core/system/polkit.nix

    # extra
    ../../extra/foot
    ../../extra/browsers
    ../../extra/neovim
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
      webcord
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
      swaybg
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
