{
  lib,
  config,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.cnstlab = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ifTheyExist [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "git"
      "mysql"
      "docker"
      "libvirtd"
      "qemu-libvirtd"
      "kvm"
      "network"
      "gamemode"
      "adbusers"
      "rtkit"
      "users"
      "plocate"
      "fuse"
    ];
  };

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
  ];

  boot.initrd.luks.devices."luks-47b35d4b-467a-4637-a5f9-45177da62897".device = "/dev/disk/by-uuid/47b35d4b-467a-4637-a5f9-45177da62897";

  networking.hostName = "cnixlab";

  environment.variables.NH_FLAKE = "/home/cnstlab/.nix-config";

  #   # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkDefault "25.05";
}
