{
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
    ./server.nix
  ];

  networking = {
    hostName = "ziggy";
  };

  system.stateVersion = lib.mkDefault "25.11";
}
