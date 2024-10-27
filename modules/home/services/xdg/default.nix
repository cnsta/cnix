{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkEnableOption elem;
  browser =
    if elem osConfig.networking.hostName ["cnix" "cnixpad"]
    then "zen.desktop"
    else "firefox.desktop";
  cfg = config.home.services.xdg;
in {
  options = {
    home.services.xdg.enable = mkEnableOption "Enables XDG settings";
  };
  config = mkIf cfg.enable {
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
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = browser;
          "text/xml" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/chrome" = browser;
          "application/x-extension-htm" = browser;
          "application/x-extension-html" = browser;
          "application/x-extension-shtml" = browser;
          "application/x-extension-xhtml" = browser;
          "application/x-extension-xht" = browser;
          "application/xhtml+xml" = browser;
          "application/json" = browser;
          "application/pdf" = "org.pwmt.zathura.desktop";
          "inode/directory" = "thunar.desktop";

          "image/apng" = "feh.desktop";
          "image/avif" = "feh.desktop";
          "image/bmp" = "feh.desktop";
          "image/gif" = "feh.desktop";
          "image/jpeg" = "feh.desktop";
          "image/png" = "feh.desktop";
          "image/svg+xml" = "feh.desktop";
          "image/tiff" = "feh.desktop";
          "image/webp" = "feh.desktop";

          "video/H264" = ["mpv.desktop" "vlc.desktop"];
          "video/x-msvideo" = ["mpv.desktop" "vlc.desktop"];
          "video/mp4" = ["mpv.desktop" "vlc.desktop"];
          "video/mpeg" = ["mpv.desktop" "vlc.desktop"];
          "video/ogg" = ["mpv.desktop" "vlc.desktop"];
          "video/mp2t" = ["mpv.desktop" "vlc.desktop"];
          "video/webm" = ["mpv.desktop" "vlc.desktop"];
          "video/3gpp" = ["mpv.desktop" "vlc.desktop"];
          "video/3gpp2" = ["mpv.desktop" "vlc.desktop"];

          "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
          "application/zip" = "org.gnome.FileRoller.desktop";
          "application/vnd.rar" = "org.gnome.FileRoller.desktop";
          "application/x-bzip" = "org.gnome.FileRoller.desktop";
          "application/x-bzip2" = "org.gnome.FileRoller.desktop";
          "application/x-tar" = "org.gnome.FileRoller.desktop";
          "application/gzip" = "org.gnome.FileRoller.desktop";
        };
      };
    };
  };
}
