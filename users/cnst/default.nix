{
  pkgs,
  lib,
  config,
  # osConfig,
  ...
}:
# let
#   isCnixpad = osConfig.networking.hostName == "cnixpad";
# in
{
  imports = [
    ./modules
  ];
  # ++ lib.optionals isCnixpad [./cpmodules.nix];

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
      BROWSER = "zen";
      EDITOR = "hx";
      TERM = "xterm-256color";

      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/cnst/.steam/root/compatibilitytools.d";
      QT_QPA_PLATFORM = "wayland";
      XDG_SESSION_TYPE = "wayland";
      # GEMINI_API_KEY = "$(cat ${config.age.secrets.gcapi.path})";
    };
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs.home-manager.enable = true;

  # systemd.user.targets.tray.Unit.Requires = lib.mkForce ["graphical-session.target"];
}
