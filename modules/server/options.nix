{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.cnix.server;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  options.cnix.server = {
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
      type = lib.types.attrsOf (
        lib.types.submodule (
          {name, ...} @ svcArgs: let
            svc = svcArgs.config;
            displayName = titleCase name;
            iconName = "${name}.svg";
            titleCase = s:
              lib.concatMapStringsSep " "
              (w:
                if w == ""
                then w
                else lib.toUpper (lib.substring 0 1 w) + lib.substring 1 (-1) w)
              (lib.splitString "-" s);
          in {
            options = {
              enable = lib.mkEnableOption "the service";
              routed = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether this service is included in automated reverse proxy routing and DNS records.";
              };
              subdomain = lib.mkOption {
                type = lib.types.str;
                default = name;
                defaultText = lib.literalExpression "the attribute name";
                description = ''
                  Subdomain for the service. Defaults to the attribute name;
                  override only when the public name differs (forgejo -> git).
                '';
              };
              exposure = lib.mkOption {
                type = lib.types.enum [
                  "local"
                  "public"
                  "tunnel"
                  "dedicated-tunnel"
                  "tailscale"
                ];
                default = "local";
                description = "Controls where the service is exposed";
              };
              tunnelViaTraefik = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Send this service's tunnel ingress to Traefik on loopback instead of
                  straight to its port. Needed when several routers share a hostname.
                '';
              };
              ingress = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                default = {};
                description = "Extra cloudflared ingress entries as subdomain -> service URL mappings.";
                example = {
                  "matrix" = "http://127.0.0.1:11338";
                };
              };
              auth = mkOption {
                type = types.bool;
                default = svc.exposure == "local";
                description = ''
                  Put Authelia forwardAuth in front of this service's Traefik router.
                  Disable for services with their own auth, or whose native clients
                  can't complete a browser redirect (mobile apps, API consumers).
                '';
              };
              middlewares = mkOption {
                type = types.listOf types.str;
                default = [];
                description = "Extra Traefik middlewares, applied after the access gate.";
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
                      example = lib.literalExpression ''
                        pkgs.writeText "cloudflare-credentials.json" '''
                        {"AccountTag":"secret","TunnelSecret":"secret","TunnelID":"secret"}
                        '''
                      '';
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
                default = {};
                type = lib.types.submodule {
                  options = {
                    name = lib.mkOption {
                      type = lib.types.str;
                      default = displayName;
                      defaultText = lib.literalExpression "the attribute name, title-cased";
                      description = "Display name on the homepage.";
                    };
                    description = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      description = "A short description for the homepage tile.";
                    };
                    icon = lib.mkOption {
                      type = lib.types.str;
                      default = iconName;
                      defaultText = lib.literalExpression "\"\${name}.svg\"";
                      description = "Icon filename for the homepage tile.";
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
          }
        )
      );
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
