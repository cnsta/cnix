{
  pkgs,
  self,
  ...
}: {
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

      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/cnst/.steam/root/compatibilitytools.d"; # proton and steam compat
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
  # age.secrets.secret1.file = "${self}/secrets/openai.age";

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}
