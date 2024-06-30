{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
            SDL2
            SDL2_image
          ];
      };
    };
  };
}
