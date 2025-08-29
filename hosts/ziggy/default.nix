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
      "fail2ban"
      "vaultwarden"
      "qbittorrent"
      "lidarr"
      "prowlarr"
      "bazarr"
      "sonarr"
      "radarr"
      "media"
      "share"
      "pihole"
    ];
  };

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./settings.nix
    ./server.nix
  ];

  networking = {
    hostName = "ziggy";
  };

  environment.variables.NH_FLAKE = "/home/cnst/.nix-config";

  #   # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkDefault "25.11";
}
