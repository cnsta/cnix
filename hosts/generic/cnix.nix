{
  environment = {
    etc."xdg/user-dirs.defaults".text = ''
      DESKTOP=desktop
      DOWNLOAD=documents/downloads
      TEMPLATES=documents/templates
      PUBLICSHARE=documents/share
      DOCUMENTS=documents
      MUSIC=media/music
      PICTURES=media/photos
      VIDEOS=media/video
    '';
  };

  time.timeZone = "Europe/Stockholm";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "sv_SE.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_NAME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_TELEPHONE = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };
  };
}
