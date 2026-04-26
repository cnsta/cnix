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

  system.stateVersion = lib.mkDefault "25.11";
}
