{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "~/media/images/nix.png"
        "~/media/images/stacks.png"
        "~/media/images/ship.png"
        "~/media/images/cabin.png"
        "~/media/images/dunes.png"
        "~/media/images/globe.png"
        "~/media/images/space.jpg"
        "~/media/images/galaxy.png"
        "~/media/images/deathstar.png"
        "~/media/images/trollskog.png"
      ];

      wallpaper = [
        # cnix
        "DP-3,~/media/images/dunes.png"
        # adampad
        "eDP-1,~/media/images/dunes.png"
        # toothpc
        "DVI-D-1,~/media/images/dunes.png"
        # "DP-1,/share/wallpapers/cat_pacman.png"
      ];
    };
  };
}
