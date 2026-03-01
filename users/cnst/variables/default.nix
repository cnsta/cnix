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
        VISUAL = "hx";
        DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
      }
    else
      {
        EDITOR = "hx";
        VISUAL = "hx";
        DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
        # VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
        # STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/cnst/.steam/root/compatibilitytools.d";
        GDK_BACKEND = "wayland,x11";
        CLUTTER_BACKEND = "wayland";
      };
in
{
  home.sessionVariables = hostSpecificVariables;
}
