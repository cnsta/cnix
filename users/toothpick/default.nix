{pkgs, ...}: {
  imports = [
    ./modules
  ];
  home = {
    username = "toothpick";
    homeDirectory = "/home/toothpick";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];

    packages = with pkgs; [
      # user specific pkgs
      filezilla
    ];
    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      TERM = "xterm-256color";

      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/toothpick/.steam/root/compatibilitytools.d"; # proton and steam compat
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
      EGL_PLATFORM = "wayland";
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
