{
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    xkb.layout = "se";
  };
}
