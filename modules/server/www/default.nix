{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    ;
  cfg = config.server.www;
  srv = config.server;
in
{
  options.server.www = {
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

    server = {
      fail2ban = lib.mkIf config.server.www.enable {
        jails = {
          nginx-404 = {
            serviceName = "nginx";
            failRegex = ''^.*\[error\].*directory index of.* is forbidden.*client: <HOST>.*$'';
            ignoreRegex = "";
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
        virtualHosts."webfinger" = {
          forceSSL = false;
          serverName = cfg.url;
          root = "/var/www/webfinger";

          locations."= /.well-known/webfinger" = {
            root = "/var/www/webfinger";
            extraConfig = ''
              default_type application/jrd+json;
              try_files /.well-known/webfinger =404;
            '';
          };

          locations."= /robots.txt" = {
            root = "/var/www/webfinger";
            extraConfig = ''
              default_type text/plain;
              try_files /robots.txt =404;
            '';
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

    environment.etc = {
      "webfinger/.well-known/webfinger".text = ''
        {
          "subject": "acct:adam@${cfg.url}",
          "links": [
            {
              "rel": "http://openid.net/specs/connect/1.0/issuer",
              "href": "https://auth.${cfg.url}/application/o/tailscale/"
            }
          ]
        }
      '';

      "webfinger/robots.txt".text = ''
        User-agent: *
        Disallow: /
      '';
    };

    services.traefik.dynamicConfigOptions.http = {
      routers.webfinger = {
        entryPoints = [ "websecure" ];
        rule = "Host(`${cfg.url}`) && Path(`/.well-known/webfinger`)";
        service = "webfinger";
        tls.certResolver = "letsencrypt";
      };

      services.webfinger.loadBalancer.servers = [
        { url = "http://127.0.0.1:8283"; }
      ];
    };
  };
}
