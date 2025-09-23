{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  unit = "authentik";
  cfg = config.server.${unit};
  srv = config.server;
in {
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "auth.${srv.domain}";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Authentik";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Open Source Identity and Access Management";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "authentik.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.authentikEnv = {
      file = "${self}/secrets/authentikEnv.age";
      owner = "authentik";
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

      traefik = {
        dynamicConfigOptions = {
          http = {
            middlewares = {
              authentik = {
                forwardAuth = {
                  tls.insecureSkipVerify = true;
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
                rule = "Host(`${cfg.url}`) || HostRegexp(`{subdomain:[a-z0-9]+}.${srv.domain}`) && PathPrefix(`/outpost.goauthentik.io/`)";
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
