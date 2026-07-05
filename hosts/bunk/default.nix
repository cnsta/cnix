{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
  ];

  networking.hostName = "bunk";

  system.stateVersion = lib.mkDefault "26.05";
}
