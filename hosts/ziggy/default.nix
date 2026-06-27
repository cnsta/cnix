{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
  ];

  networking = {
    hostName = "ziggy";
  };

  system.stateVersion = lib.mkDefault "25.11";
}
