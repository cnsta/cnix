{ osConfig, pkgs, ... }:
let
  user = osConfig.settings.accounts.username;

  variables = {
    VISUAL = "hx";
    DEFAULT_BROWSER = (pkgs.librewolf + "/bin/librewolf");
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
in
{
  home = {
    username = user;
    homeDirectory = ("/home/" + user);
    stateVersion = "26.05";
    sessionVariables = variables;
    extraOutputsToInstall = [
      "doc"
      "devdoc"
    ];
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs.home-manager.enable = true;
}
