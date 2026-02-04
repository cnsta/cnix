{
  osConfig,
  pkgs,
  ...
}:
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
        QT_QPA_PLATFORM = "wayland;xcb";
        XDG_SESSION_TYPE = "wayland";
        GDK_BACKEND = "wayland,x11";
        SDL_VIDEODRIVER = "wayland,x11,windows";
        CLUTTER_BACKEND = "wayland";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };
in
{
  home.sessionVariables = hostSpecificVariables;
}
