{
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.graceful = true;
    efi.canTouchEfiVariables = false;
  };
}
