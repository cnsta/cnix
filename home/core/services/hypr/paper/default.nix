{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = ["./src/nix.png" "./src/wallpaper.png"];

      wallpaper = [
        "DP-3,./src/wallpaper.png"
        # "DP-1,/share/wallpapers/cat_pacman.png"
      ];
    };
  };
}
