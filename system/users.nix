{
  config,
  pkgs,
  lib,
  ...
}: let
  user = config.cnix.settings.accounts.username;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  config = {
    users.users.${user} = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ifTheyExist [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "kvm"
        "users"
        "plocate"
        "i2c"
        "fail2ban"
        "vaultwarden"
        "share"
        "render"
        "traefik"
        "immich"
      ];
    };
  };
}
