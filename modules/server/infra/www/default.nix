{
  lib,
  config,
  self,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.server.infra.www;
in
{
  options.server.infra.www = {
    enable = mkEnableOption {
      description = "Enable personal website";
    };
    url = mkOption {
      default = "";
      type = types.str;
      description = ''
        Public domain name to be used to access the server services via Traefik reverse proxy
      '';
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8283;
      description = "The port to host webservice on.";
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
  };

  config = mkIf cfg.enable {
    age.secrets = {
      wwwCloudflared.file = "${self}/secrets/wwwCloudflared.age";
    };

    server.infra = {
      fail2ban = {
        jails = {
          nginx-404 = {
            serviceName = "nginx";
            failRegex = ''^.*\[error\].*directory index of.* is forbidden.*client: <HOST>.*$'';
            ignoreRegex = '''';
            maxRetry = 5;
          };
        };
      };
    };

    services = {
      nginx = {
        enable = true;
        defaultListen = [
          {
            addr = "127.0.0.1";
            port = 8283;
          }
        ];
        virtualHosts = {
          "www" = {
            forceSSL = false;
            serverName = cfg.url;
            root = "/var/www";

            locations."= /.well-known/webfinger" = {
              extraConfig = ''
                default_type application/jrd+json;
                try_files /.well-known/webfinger =404;
              '';
            };

            locations."= /robots.txt" = {
              extraConfig = ''
                default_type text/plain;
                try_files /robots.txt =404;
              '';
            };
          };

          "ts" = {
            forceSSL = false;
            serverName = "ts.${cfg.url}";
            root = "/var/www";

            locations."/" = {
              extraConfig = ''
                index ts.html;
                try_files $uri $uri/ =404;
              '';
            };
          };
        };
      };

      cloudflared = {
        enable = true;
        tunnels.${cfg.cloudflared.tunnelId} = {
          credentialsFile = cfg.cloudflared.credentialsFile;
          default = "http_status:404";
          ingress."${cfg.url}".service = "http://127.0.0.1:8283";
        };
      };
    };

    services.traefik.dynamicConfigOptions.http = {
      routers = {
        www = {
          entryPoints = [ "websecure" ];
          rule = "Host(`${cfg.url}`) && Path(`/.well-known/webfinger`)";
          service = "www";
          tls.certResolver = "letsencrypt";
        };

        ts = {
          entryPoints = [ "websecure" ];
          rule = "Host(`ts.${cfg.url}`)";
          service = "ts";
          tls.certResolver = "letsencrypt";
        };
      };

      services = {
        www.loadBalancer.servers = [
          { url = "http://127.0.0.1:8283"; }
        ];

        ts.loadBalancer.servers = [
          { url = "http://127.0.0.1:8283"; }
        ];
      };
    };
  };
}
