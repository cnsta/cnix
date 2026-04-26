{
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
  ];

  boot.initrd.luks.devices."luks-0ad53967-bb38-4485-be75-ca55ae4c3b68".device =
    "/dev/disk/by-uuid/0ad53967-bb38-4485-be75-ca55ae4c3b68";
  networking.hostName = "bunk";

  system.stateVersion = lib.mkDefault "25.11";
}
