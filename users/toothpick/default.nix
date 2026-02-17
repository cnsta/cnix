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
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
      GBM_BACKEND = "nvidia-drm";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs.home-manager.enable = true;
}
