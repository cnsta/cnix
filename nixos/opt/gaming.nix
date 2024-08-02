{pkgs, ...}: {
  imports = [
    ./steam
    ./lutris
    ./bottles
    ./gamemode
    ./gamescope
    ./corectrl
  ];
  environment = {
    systemPackages = with pkgs; [
      # Misc
      protonup
      winetricks
    ];
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/cnst/.steam/root/compatibilitytools.d";
    };
  };
}
