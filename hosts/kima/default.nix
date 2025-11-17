{
  lib,
  config,
  pkgs,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.cnst = {
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
    ./disko.nix
    ./modules.nix
    ./settings.nix
  ];

  networking = {
    hostName = "kima";
    hostId = "723158aa";
  };

  boot.zfs.package = pkgs.zfs_unstable;

  environment.variables = {
    NH_FLAKE = "/home/cnst/.nix-config";
  };

  system.stateVersion = lib.mkDefault "25.11";
}
