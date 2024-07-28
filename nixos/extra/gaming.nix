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

      # Lutris dependencies
      (lutris.override {
        extraLibraries = pkgs: [
          SDL2
          SDL2_image
          glib
          wineWowPackages.stable
          wineWowPackages.staging
          wineWowPackages.waylandFull
          winetricks
          # python312Packages.pygame-sdl2
          libGL
          ffmpeg
        ];
      })
    ];
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/cnst/.steam/root/compatibilitytools.d";
    };
  };
}
