{
  config,
  pkgs,
  ...
}:
let
  user = config.settings.accounts.username;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.${user} = {
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
      "i2c"
      "wireshark"
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
      "immich"
      "pihole"
    ];
  };
}
