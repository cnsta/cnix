{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
  ];

  time.hardwareClockInLocalTime = true;

  system.stateVersion = lib.mkDefault "25.11";
}
