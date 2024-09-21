{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  isCnixpad = osConfig.networking.hostName == "cnixpad";
in {
  imports =
    [
      ./modules.nix
      ./git.nix
      ./shell.nix
    ]
    ++ lib.optionals isCnixpad [./cpmodules.nix];
  home = {
    username = "cnst";
    homeDirectory = "/home/cnst";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];
    packages = with pkgs; [
      # misc.system
      bun
    ];

    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "hx";
      TERM = "xterm-256color";

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
  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}
