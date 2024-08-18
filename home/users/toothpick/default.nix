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
    ];
    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      TERM = "foot";

      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/toothpick/.steam/root/compatibilitytools.d"; # proton and steam compat
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
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
