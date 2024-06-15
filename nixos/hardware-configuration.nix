{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [  (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernalModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernalModules = [ ];
  boot.kernalModules = [ "kvm-amd ];
  boot.extraModulePackages = [ ];

  filesSystems."/" =
    { device = "/dev/disk/by-uuid/66495946-e6f4-48db-bab3-e1d4cafc326d";
      fsType = "ext4";
    };

    swapDevices = [ ];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
