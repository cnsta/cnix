{
  monitors = [
    {
      name = "DP-3";
      width = 2560;
      height = 1440;
      refreshRate = 240;
      bitDepth = 10;
      position = "0x0";
      workspace = "1";
      primary = true;
    }
    {
      name = "DP-4";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      position = "2560x360";
      workspace = "4";
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
