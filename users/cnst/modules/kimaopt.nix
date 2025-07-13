{
  accounts = {
    username = "cnst";
    mail = "adam@cnst.dev";
    sshUser = "kima";
  };
  monitors = [
    {
      name = "DP-3";
      width = 2560;
      height = 1440;
      refreshRate = 240;
      position = "0x0";
      transform = 0;
      bitDepth = 10;
      workspace = "1";
      primary = true;
    }
    {
      name = "DP-4";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      position = "2560x0";
      transform = 3;
      workspace = "5";
      primary = false;
    }
    {
      name = "eDP-1";
      width = 1920;
      height = 1200;
      refreshRate = 60;
      workspace = "1";
      primary = false;
    }
  ];
  theme = {
    background = {
      lockscreen = "wallpaper_2";
      desktop = "wallpaper_1";
    };
  };
}
