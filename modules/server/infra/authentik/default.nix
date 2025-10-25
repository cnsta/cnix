{
  config,
  lib,
  self,
  ...
}: let
  unit = "authentik";
  cfg = config.server.infra.${unit};
  srv = config.server.infra;
in {
  options.server.infra.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "auth.${srv.www.url}";
    };
    port = lib.mkOption {
      type = lib.types.port;
      description = "The local port the service runs on";
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
    homepage = {
      name = "Authentik";
      description = "An open-source IdP for modern SSO";
      icon = "authentik.svg";
      category = "Services";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets = {
      authentikEnv = {
        file = "${self}/secrets/authentikEnv.age";
      };
      authentikCloudflared = {
        file = "${self}/secrets/authentikCloudflared.age";
      };
    };

    server.infra = {
      fail2ban = {
        jails = {
          authentik = {
            serviceName = "authentik";
            failRegex = ''^.*Username or password is incorrect.*IP:\s*<HOST>'';
          };
        };
      };
    };

    services = {
      authentik = {
        enable = true;
        environmentFile = config.age.secrets.authentikEnv.path;
        settings = {
          email = {
          };
          disable_startup_analytics = true;
          avatars = "initials";
        };
      };

      cloudflared = {
        enable = true;
        tunnels.${cfg.cloudflared.tunnelId} = {
          credentialsFile = cfg.cloudflared.credentialsFile;
          default = "http_status:404";
          ingress."${cfg.url}".service = "http://127.0.0.1:9000";
        };
      };

      traefik = {
        dynamicConfigOptions = {
          http = {
            middlewares = {
              authentik = {
                forwardAuth = {
                  address = "https://localhost:9443/outpost.goauthentik.io/auth/traefik";
                  trustForwardHeader = true;
                  authResponseHeaders = [
                    "X-authentik-username"
                    "X-authentik-groups"
                    "X-authentik-email"
                    "X-authentik-name"
                    "X-authentik-uid"
                    "X-authentik-jwt"
                    "X-authentik-meta-jwks"
                    "X-authentik-meta-outpost"
                    "X-authentik-meta-provider"
                    "X-authentik-meta-app"
                    "X-authentik-meta-version"
                  ];
                };
              };
            };

            services = {
              auth.loadBalancer.servers = [
                {
                  url = "http://localhost:9000";
                }
              ];
            };

            routers = {
              auth = {
                entryPoints = ["websecure"];
                rule = "Host(`${cfg.url}`) && PathPrefix(`/outpost.goauthentik.io/`)";
                service = "auth";
                tls.certResolver = "letsencrypt";
              };
            };
          };
        };
      };
    };
  };
}
