{pkgs, ...}: {
  imports = [
    # core.gui
    # ../../core/gui/ags
    ../../core/gui/hypr/cnst.nix
    # core.tui
    ../../core/tui/git/cnst.nix
    ../../core/tui/shell/cnst.nix
    # core.services
    # ../../core/services/power-monitor
  ];
  home = {
    packages = with pkgs; [
      # misc.gui
      virt-manager
      xfce.thunar
      nautilus

      # misc.tui
      ranger
      xcur2png

      # misc.system
      bun
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
