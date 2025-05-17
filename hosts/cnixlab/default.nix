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

  networking.hostName = "cnixlab";

  environment.variables.NH_FLAKE = "/home/cnstlab/.nix-config";

  #   # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkDefault "23.11";
}
