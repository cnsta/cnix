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
    # openssh.authorizedKeys.keys = [];
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
    ];
  };

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./settings.nix
  ];

  boot.initrd.luks.devices."luks-0ad53967-bb38-4485-be75-ca55ae4c3b68".device = "/dev/disk/by-uuid/0ad53967-bb38-4485-be75-ca55ae4c3b68";
  networking.hostName = "bunk";

  environment.variables.NH_FLAKE = "/home/cnst/.nix-config";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkDefault "25.05";
}
