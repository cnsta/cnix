{ osConfig, pkgs, ... }:
let
  hostSpecificVariables =
    if osConfig.networking.hostName == "bunk" then
      {
        EDITOR = "hx";
        TERM = "xterm-256color";
        DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
        QT_QPA_PLATFORM = "wayland";
        XDG_SESSION_TYPE = "wayland";
      }
    else
      {
        EDITOR = "hx";
        TERM = "xterm-256color";
        DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
        # VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
        # STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/cnst/.steam/root/compatibilitytools.d";
        QT_QPA_PLATFORM = "wayland";
        XDG_SESSION_TYPE = "wayland";
      };
in
{
  home.sessionVariables = hostSpecificVariables;
}
