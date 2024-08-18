{pkgs, ...}: {
  imports = [
    ./modules.nix
    ./git.nix
    ./shell.nix
  ];
  home = {
    username = "toothpick";
    homeDirectory = "/home/toothpick";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];

    packages = with pkgs; [
      # user specific pkgs
      filezilla
      egl-wayland
    ];
    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      TERM = "foot";

      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/toothpick/.steam/root/compatibilitytools.d"; # proton and steam compat
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      LIBVA_DRIVER_NAME = "nvidia";
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
