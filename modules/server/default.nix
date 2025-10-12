{
  lib,
  config,
  pkgs,
  ...
}: let
  hardDrives = [
    "/dev/disk/by-label/data"
  ];
  inherit (lib) mkOption types;
  cfg = config.server;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
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
    ip = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "The local IP of the service.";
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
    services = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
        options = {
          enable = lib.mkEnableOption "the service";
          subdomain = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "The subdomain for the service (e.g., 'jellyfin')";
          };
          exposure = lib.mkOption {
            type = lib.types.enum ["local" "tunnel" "tailscale"];
            default = "local";
            description = "Controls where the service is exposed";
          };
          port = lib.mkOption {
            type = lib.types.int;
            default = 80;
            description = "The port to host service on.";
          };
          configDir = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/${name}";
            description = "Configuration directory for ${name}.";
          };
          cloudflared = lib.mkOption {
            type = lib.types.submodule {
              options = {
                credentialsFile = lib.mkOption {
                  type = lib.types.str;
                  example = "/path/to/cloudflare-credentials.json";
                  # example = lib.literalExpression ''
                  #   pkgs.writeText "cloudflare-credentials.json" '''
                  #   {"AccountTag":"secret","TunnelSecret":"secret","TunnelID":"secret"}
                  #   '''
                  # '';
                };
                tunnelId = lib.mkOption {
                  type = lib.types.str;
                  example = "00000000-0000-0000-0000-000000000000";
                };
              };
            };
            description = "Cloudflare tunnel configuration for this service.";
          };
          homepage = lib.mkOption {
            type = lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "Display name on the homepage.";
                };
                description = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "A short description for the homepage tile.";
                };
                icon = lib.mkOption {
                  type = lib.types.str;
                  default = "Zervices c00l stuff";
                  description = "Icon file name for the homepage tile.";
                };
                category = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "Homepage category grouping.";
                };
                path = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  example = "/admin";
                  description = "Optional path suffix for homepage links (e.g. /admin).";
                };
              };
            };
            description = "Homepage metadata for this service.";
          };
        };
      }));
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
          "authentik"
          "traefik"
        ];
      };
    };
  };
}
