{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
  ];

  system.stateVersion = lib.mkDefault "25.11";
}
