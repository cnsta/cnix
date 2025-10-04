{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  unit = "jellyfin";
  cfg = config.server.${unit};
  srv = config.server;
in {
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/${unit}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin.${srv.www.url}";
    };
    cloudflared = {
      credentialsFile = lib.mkOption {
        type = lib.types.str;
        example = lib.literalExpression ''
          pkgs.writeText "cloudflare-credentials.json" '''
          {"AccountTag":"secret"."TunnelSecret":"secret","TunnelID":"secret"}
          '''
        '';
      };
      tunnelId = lib.mkOption {
        type = lib.types.str;
        example = "00000000-0000-0000-0000-000000000000";
      };
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Jellyfin";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "The Free Software Media System";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
  };
  config = lib.mkIf cfg.enable {
    age.secrets = {
      jellyfinCloudflared = {
        file = "${self}/secrets/jellyfinCloudflared.age";
        owner = "${srv.user}";
        group = "${srv.group}";
        mode = "0400";
      };
    };

    services = {
      cloudflared = {
        enable = true;
        tunnels.${cfg.cloudflared.tunnelId} = {
          credentialsFile = cfg.cloudflared.credentialsFile;
          default = "http_status:404";
          ingress."${cfg.url}".service = "http://127.0.0.1:8096";
        };
      };

      ${unit} = {
        enable = true;
        user = srv.user;
        group = srv.group;
      };
    };

    environment.systemPackages = with pkgs; [
      jellyfin-ffmpeg
    ];
    services.traefik = {
      dynamicConfigOptions = {
        http = {
          middlewares = {
            secureHeaders = {
              headers = {
                stsSeconds = 31536000;
                forceSTSHeader = true;
                stsIncludeSubdomains = true;
                stsPreload = true;
                browserXssFilter = true;
                frameDeny = true;
                referrerPolicy = "no-referrer";
                contentTypeNosniff = true;
                customResponseHeaders = {
                  "Content-Security-Policy" = "default-src 'self'; img-src 'self' data:; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';";
                };
              };
            };
            ratelimit = {
              rateLimit = {
                average = 10;
                burst = 20;
              };
            };
          };

          services.jellyfin.loadBalancer.servers = [{url = "http://127.0.0.1:8096";}];
          routers = {
            jellyfin = {
              entryPoints = ["websecure"];
              rule = "Host(`${cfg.url}`)";
              service = "jellyfin";
              tls.certResolver = "letsencrypt";
              middlewares = ["authentik" "secureHeaders" "ratelimit"];
            };
          };
        };
      };
    };
  };
}
