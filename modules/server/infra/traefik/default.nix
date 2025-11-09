{
  lib,
  clib,
  config,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.server.infra.traefik;
  srv = config.server;

  generateRouters = services: config:
    lib.mapAttrs' (
      name: service:
        lib.nameValuePair name {
          entryPoints = ["websecure"];
          rule = "Host(`${clib.server.mkFullDomain config service}`)";
          service = name;
          tls.certResolver = "letsencrypt";
        }
    ) (lib.filterAttrs (_: s: s.enable) services);

  generateServices = services:
    lib.mapAttrs' (name: service:
      lib.nameValuePair name {
        loadBalancer.servers = [{url = "http://localhost:${toString service.port}";}];
      }) (lib.filterAttrs (name: service: service.enable) services);
in {
  options.server.infra.traefik = {
    enable = mkEnableOption "Enable global Traefik reverse proxy with ACME";
  };

  config = mkIf cfg.enable {
    age.secrets = {
      traefikEnv = {
        file = "${self}/secrets/traefikEnv.age";
        mode = "640";
        owner = "traefik";
        group = "traefik";
      };
    };

    systemd.services.traefik = {
      serviceConfig = {
        EnvironmentFile = [config.age.secrets.traefikEnv.path];
      };
    };
    networking.firewall.allowedTCPPorts = [80 443];

    services = {
      tailscale.permitCertUid = "traefik";
      traefik = {
        enable = true;

        staticConfigOptions = {
          log = {
            level = "DEBUG";
          };

          accesslog = {filepath = "/var/lib/traefik/logs/access.log";};

          tracing = {};
          api = {
            dashboard = true;
            insecure = false;
          };

          certificatesResolvers = {
            vpn.tailscale = {};
            letsencrypt = {
              acme = {
                email = "adam@cnst.dev";
                storage = "/var/lib/traefik/cert.json";
                dnsChallenge = {
                  provider = "cloudflare";
                  resolvers = [
                    "1.1.1.1:53"
                    "1.0.0.1:53"
                  ];
                };
              };
            };
          };

          entryPoints = {
            # redis = {
            #   address = "0.0.0.0:6381";
            # };
            # postgres = {
            #   address = "0.0.0.0:5433";
            # };
            web = {
              address = ":80";
              forwardedHeaders.insecure = true;
              http.redirections.entryPoint = {
                to = "websecure";
                scheme = "https";
                permanent = true;
              };
            };

            websecure = {
              address = ":443";
              forwardedHeaders.insecure = true;
              http.tls = {
                certResolver = "letsencrypt";
                domains = [
                  {
                    main = "cnix.dev";
                    sans = ["*.cnix.dev"];
                  }
                  {
                    main = "ts.cnst.dev";
                    sans = ["*ts.cnst.dev"];
                  }
                ];
              };
            };

            experimental = {
              address = ":1111";
              forwardedHeaders.insecure = true;
            };
          };
        };

        dynamicConfigOptions = {
          http = {
            services = generateServices srv.services;

            routers =
              (generateRouters srv.services config)
              // {
                api = {
                  entryPoints = ["websecure"];
                  rule = "Host(`traefik.${srv.domain}`)";
                  service = "api@internal";
                  tls.certResolver = "letsencrypt";
                };
              };
          };
        };
      };
    };
  };
}
