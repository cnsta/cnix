{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
  ];

  system.stateVersion = lib.mkDefault "26.05";
}
