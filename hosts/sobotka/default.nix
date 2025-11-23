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
      "jellyfin"
      "render"
      "traefik"
    ];
  };

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./settings.nix
    ./server.nix
  ];

  boot.initrd.luks.devices."luks-47b35d4b-467a-4637-a5f9-45177da62897".device =
    "/dev/disk/by-uuid/47b35d4b-467a-4637-a5f9-45177da62897";

  networking = {
    hostName = "sobotka";
    hostId = "784991aa";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs = {
      package = pkgs.zfs_unstable;
      extraPools = [ "data" ];
    };
  };

  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
  };

  environment.etc."nextcloud-admin-pass".text =
    "DeHKor3x8^eqqnBXjqhQ&QBl*3!sOLg8agfzOILihju#^0!2AfJ9W*vn";

  environment.variables.NH_FLAKE = "/home/cnst/.nix-config";

  #   # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkDefault "25.05";
}
