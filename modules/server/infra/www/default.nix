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

            locations."= /.well-known/matrix/server" = {
              extraConfig =
                let
                  matrixDomain = "${config.server.services.continuwuity.subdomain}.${cfg.url}";
                in
                ''
                  default_type application/json;
                  return 200 '{"m.server": "${matrixDomain}:443"}';
                '';
            };

            locations."= /.well-known/matrix/client" = {
              extraConfig =
                let
                  matrixDomain = "${config.server.services.continuwuity.subdomain}.${cfg.url}";
                  clientConfig = builtins.toJSON {
                    "m.homeserver" = {
                      base_url = "https://${matrixDomain}";
                    };
                    "org.matrix.msc4143.rtc_foci" = [
                      {
                        type = "livekit";
                        livekit_service_url = "https://${matrixDomain}/livekit/jwt";
                      }
                    ];
                  };
                in
                ''
                  default_type application/json;
                  add_header Access-Control-Allow-Origin *;
                  return 200 '${clientConfig}';
                '';
            };

            locations."= /.well-known/matrix/support" = {
              extraConfig = ''
                default_type application/json;
                add_header Access-Control-Allow-Origin *;
                return 200 '${
                  builtins.toJSON {
                    contacts = [
                      {
                        email_address = "cnst@cnix.dev";
                        matrix_id = "@cnst:cnst.dev";
                        role = "m.role.admin";
                      }
                    ];
                  }
                }';
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
          ingress =
            let
              # Auto-generate from services with exposure = "tunnel"
              tunnelServices = lib.filterAttrs (
                _: svc: svc.enable && svc.exposure == "tunnel" && svc.subdomain != ""
              ) config.server.services;
              autoIngress = lib.mapAttrs' (
                _: svc:
                lib.nameValuePair "${svc.subdomain}.${cfg.url}" {
                  service = "http://127.0.0.1:${toString svc.port}";
                }
              ) tunnelServices;
              # Collect extra ingress from all services
              extraIngress = lib.foldlAttrs (
                acc: _: svc:
                acc
                // lib.mapAttrs' (sub: url: lib.nameValuePair "${sub}.${cfg.url}" { service = url; }) svc.ingress
              ) { } (lib.filterAttrs (_: svc: svc.enable) config.server.services);
            in
            autoIngress
            // extraIngress
            // {
              "${cfg.url}".service = "http://127.0.0.1:8283";
            };
        };
      };

      traefik.dynamicConfigOptions.http = {
        routers = {
          www = {
            entryPoints = [ "websecure" ];
            rule = "Host(`${cfg.url}`) && PathPrefix(`/.well-known/`)";
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
  };
}
