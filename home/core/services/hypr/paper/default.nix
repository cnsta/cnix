{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = ["~/media/images/nix.png" "~/media/images/wallpaper.png"];

      wallpaper = [
        "DP-3,~/media/images/wallpaper.png"
        # "DP-1,/share/wallpapers/cat_pacman.png"
      ];
    };
  };
}
