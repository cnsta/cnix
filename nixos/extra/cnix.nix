{pkgs, ...}: {
  imports = [
    ./steam
    ./lutris
    ./bottles
    ./gamemode
    ./gamescope
    ./workstation
  ];
  environment = {
    systemPackages = with pkgs; [
      # Dev
      fd
      python3
      hyprlang

      # Misc
      protonup

      # Lutris dependencies
      (lutris.override {
        extraLibraries = pkgs: [
          SDL2
          SDL2_image
          glib
          egl-wayland
          wineWowPackages.stable
          wineWowPackages.staging
          wineWowPackages.waylandFull
          winetricks
          python312Packages.pygame-sdl2
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