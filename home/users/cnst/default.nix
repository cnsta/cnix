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
    username = "cnst";
    homeDirectory = "/home/cnst";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];

    packages = with pkgs; [
      # misc.gui
      virt-manager
      xfce.thunar

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
    };
  };
  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}
