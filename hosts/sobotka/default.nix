{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
    ./server.nix
  ];

  boot.initrd.luks.devices = {
    # root
    "luks-4f289fde-55ed-4b05-a6ee-d396db2a887b".device =
      "/dev/disk/by-uuid/4f289fde-55ed-4b05-a6ee-d396db2a887b";
    "luks-47b35d4b-467a-4637-a5f9-45177da62897".device =
      "/dev/disk/by-uuid/47b35d4b-467a-4637-a5f9-45177da62897";

    # zpool
    # sda
    "luks-dba197aa-b9e1-4d56-95a5-13a1d06ca7c5".device =
      "/dev/disk/by-uuid/dba197aa-b9e1-4d56-95a5-13a1d06ca7c5";
    # sdb
    "luks-fe85369f-e589-44e0-97d0-96559be46e16".device =
      "/dev/disk/by-uuid/fe85369f-e589-44e0-97d0-96559be46e16";
    # sdc
    "luks-1df49738-f73e-4f0d-8161-ce076657f0eb".device =
      "/dev/disk/by-uuid/1df49738-f73e-4f0d-8161-ce076657f0eb";
    # sdd
    "luks-96118bd7-e67a-4016-a787-6d83b04f3579".device =
      "/dev/disk/by-uuid/96118bd7-e67a-4016-a787-6d83b04f3579";
    # logs
    "luks-3c46303f-b8b5-476a-98f4-e0d455880ca5".device =
      "/dev/disk/by-uuid/3c46303f-b8b5-476a-98f4-e0d455880ca5";
    # cache
    "luks-b9191e25-9baa-4e0c-b18c-b927d56841ad".device =
      "/dev/disk/by-uuid/b9191e25-9baa-4e0c-b18c-b927d56841ad";
  };

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
