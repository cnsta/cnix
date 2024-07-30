{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  system,
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

  programs.dconf.enable = true;

  imports = [
    ./system.nix
    ./hardware-configuration.nix
    ./substituters.nix
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
  environment.systemPackages = [pkgs.scx];

  boot.kernelParams = [
    "amd_pstate=active"
    "quiet"
    "splash"
  ];

  environment.sessionVariables = {
    FLAKE = "/home/cnst/.nix-config";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkDefault "23.11";
}
