{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
  ];

  time.hardwareClockInLocalTime = false;

  system.stateVersion = lib.mkDefault "25.11";
}
