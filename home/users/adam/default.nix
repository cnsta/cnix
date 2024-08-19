{pkgs, ...}: {
  imports = [
    ./modules.nix
    ./git.nix
    ./shell.nix
  ];
  home = {
    username = "adam";
    homeDirectory = "/home/adam";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];

    packages = with pkgs; [
      # misc.system
      brightnessctl
      bun
    ];
    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      TERM = "xterm-256color";

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
