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

  networking.hostName = "cnixtop";

  environment.variables.FLAKE = "/home/cnst/.nix-config";

  programs.hyprland.settings = {
    monitor = [
      "DP-3,2560x1440@240,0x0,1,transform,0,bitdepth,10"
      "DP-4,1920x1080@60,auto,1,transform,3"
    ];
  };

  #   # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkDefault "23.11";
}
