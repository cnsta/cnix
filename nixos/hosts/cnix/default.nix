{
  lib,
  config,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.cnst = {
    isNormalUser = true;
    shell = pkgs.zsh;
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
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;

  boot.kernelParams = [
    "amd_pstate=active"
    "quiet"
    "splash"
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkDefault "23.11";
}
