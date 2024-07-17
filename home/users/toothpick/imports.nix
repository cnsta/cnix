{pkgs, ...}: {
  imports = [
    # core.gui
    ../../core/gui/gtk
    ../../core/gui/waybar
    ../../core/gui/browsers
    ../../core/gui/xdg
    ../../core/gui/discord
    ../../core/gui/vscode
    ../../core/gui/utility
    # core.tui
    ../../core/tui/git/toothpick.nix
    ../../core/tui/shell/toothpick.nix
    ../../core/tui/alacritty
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
    };
  };
}
