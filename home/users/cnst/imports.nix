{pkgs, ...}: {
  imports = [
    # core.gui
    ../../core/gui/gtk
    ../../core/gui/waybar
    ../../core/gui/ags
    ../../core/gui/browsers
    ../../core/gui/xdg
    ../../core/gui/discord
    ../../core/gui/hypr
    ../../core/gui/utility
    # core.tui
    ../../core/tui/git/cnst.nix
    ../../core/tui/shell/cnst.nix
    ../../core/tui/foot
    ../../core/tui/alacritty
    ../../core/tui/neovim
    # core.services
    ../../core/services/mako
    ../../core/services/polkit
    ../../core/services/hypr
    ../../core/services/power-monitor
  ];
  home = {
    packages = with pkgs; [
      # misc.gui
      virt-manager
      xfce.thunar

      # misc.tui
      ranger

      # misc.system
      adwaita-icon-theme
      qt5.qtwayland
      qt6.qtwayland
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
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
