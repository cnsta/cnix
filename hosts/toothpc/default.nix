{
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
  ];

  networking.hostName = "toothpc";

  time.hardwareClockInLocalTime = true;

  system.stateVersion = lib.mkDefault "25.11";
}
