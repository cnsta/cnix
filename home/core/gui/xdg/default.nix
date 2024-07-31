{
  pkgs,
  config,
  ...
}: {
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/media/music";
      pictures = "${config.home.homeDirectory}/media/images";
      publicShare = "${config.home.homeDirectory}/documents/share";
      templates = "${config.home.homeDirectory}/documents/templates";
      videos = "${config.home.homeDirectory}/media/videos";
    };
  };
  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
