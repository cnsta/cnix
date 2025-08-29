{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.server;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  options.server = {
    enable = lib.mkEnableOption "The server services and configuration variables";
    email = mkOption {
      default = "";
      type = types.str;
      description = ''
        Email name to be used to access the server services via Caddy reverse proxy
      '';
    };
    domain = mkOption {
      default = "";
      type = types.str;
      description = ''
        Domain name to be used to access the server services via Caddy reverse proxy
      '';
    };
    user = lib.mkOption {
      default = "share";
      type = lib.types.str;
      description = ''
        User to run the server services as
      '';
    };
    group = lib.mkOption {
      default = "share";
      type = lib.types.str;
      description = ''
        Group to run the server services as
      '';
    };
    uid = lib.mkOption {
      default = 1000;
      type = lib.types.int;
      description = ''
        UID to run the server services as
      '';
    };
    gid = lib.mkOption {
      default = 1000;
      type = lib.types.int;
      description = ''
        GID to run the server services as
      '';
    };

    timeZone = lib.mkOption {
      default = "Europe/Stockholm";
      type = lib.types.str;
      description = ''
        Time zone to be used for the server services
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    users = {
      groups.${cfg.group} = {
        gid = cfg.gid;
      };
      users.${cfg.user} = {
        uid = cfg.uid;
        isSystemUser = true;
        group = cfg.group;
        extraGroups = ifTheyExist [
          "audio"
          "video"
          "docker"
          "libvirtd"
          "qemu-libvirtd"
          "rtkit"
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
          "render"
          "input"
        ];
      };
    };
  };
}
