{pkgs, ...}: {
  imports = [
    # CORE
    # .gui
    ../../core/gui/anyrun
    ../../core/gui/gtk
    ../../core/gui/mako
    ../../core/gui/waybar
    ../../core/gui/xdg
    # .tui
    ../../core/tui/git/cnst.nix
    ../../core/tui/shell/cnst.nix
    # .system
    ../../core/system/polkit.nix

    # EXTRA
    ../../extra/foot
    ../../extra/firefox
    ../../extra/neovim
  ];
  home = {
    packages = with pkgs; [
      # MISCELLANEOUS
      # .gui
      gnome.file-roller
      gnome.gnome-calculator
      keepassxc
      nwg-look
      oculante
      pavucontrol
      qbittorrent
      virt-manager
      webcord
      xfce.thunar

      # .tui
      alacritty
      btop
      calcurse
      fastfetch
      htop
      ranger

      # .system
      gnome.adwaita-icon-theme
      grimblast
      hyprpicker
      networkmanagerapplet
      pamixer
      qt5.qtwayland
      qt6.qtwayland
      slurp
      swaybg
      thefuck
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
