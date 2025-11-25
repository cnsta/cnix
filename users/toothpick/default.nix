{ pkgs, ... }:
{
  imports = [
    ./modules
  ];

  home = {
    username = "toothpick";
    homeDirectory = "/home/toothpick";
    stateVersion = "23.11";
    extraOutputsToInstall = [
      "doc"
      "devdoc"
    ];

    packages = with pkgs; [
    ];

    sessionVariables = {
      BROWSER = "zen";
      EDITOR = "nvim";
      TERM = "xterm-256color";
      # STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/toothpick/.steam/root/compatibilitytools.d"; # proton and steam compat
      # LIBVA_DRIVER_NAME = "nvidia";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # NVD_BACKEND = "direct";
      # GBM_BACKEND = "nvidia-drm";
    };
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs.home-manager.enable = true;
}
