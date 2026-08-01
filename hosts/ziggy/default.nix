{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
  ];

  documentation = {
    enable = false;
    nixos.enable = false;
    man.enable = false;
  };

  boot.tmp.useTmpfs = false;

  system.stateVersion = lib.mkDefault "25.11";
}
