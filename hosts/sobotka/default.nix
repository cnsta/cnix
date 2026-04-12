{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./settings.nix
    ./server.nix
  ];

  boot.initrd.luks.devices."luks-47b35d4b-467a-4637-a5f9-45177da62897".device =
    "/dev/disk/by-uuid/47b35d4b-467a-4637-a5f9-45177da62897";

  networking = {
    hostName = "sobotka";
    hostId = "784991aa";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs = {
      package = pkgs.zfs_unstable;
      extraPools = [ "data" ];
    };
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
  };

  system.stateVersion = lib.mkDefault "25.05";
}
