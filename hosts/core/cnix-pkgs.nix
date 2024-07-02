{pkgs, ...}: {
  environment = {
    systemPackages = [
      # Dev
      pkgs.fd
      pkgs.python3
      pkgs.hyprlang

      # Util
      pkgs.tmux
      pkgs.tmuxifier

      # Misc
      pkgs.protonup
    ];
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/cnst/.steam/root/compatibilitytools.d";
    };
  };
}
