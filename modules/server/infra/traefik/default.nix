{
  lib,
  clib,
  config,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types;

  cfg = config.server.infra.traefik;
  srv = config.server;

  generateRouters = services: config:
    lib.mapAttrs' (
      name: service:
        lib.nameValuePair name {
          entryPoints = ["websecure"];
          # FIX 3: Use backticks for the Host rule and interpolation
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

  getCloudflareCredentials = hostname:
    if hostname == "ziggy"
    then config.age.secrets.cloudflareDnsCredentialsZiggy.path
    else if hostname == "sobotka"
    then config.age.secrets.cloudflareDnsCredentials.path
    else throw "Unknown hostname: ${hostname}";
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
      crowdsecApi.file = "${self}/secrets/crowdsecApi.age";
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
              # http.middlewares = "crowdsec@file";
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
              # http.middlewares = "crowdsec@file";
            };

            experimental = {
              address = ":1111";
              forwardedHeaders.insecure = true;
            };
          };

          experimental = {
            # Install the Crowdsec Bouncer plugin
            plugins = {
              #enabled = "true";
              bouncer = {
                moduleName = "github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin";
                version = "v1.4.5";
              };
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
            # middlewares = {
            #   crowdsec = {
            #     plugin = {
            #       bouncer = {
            #         enabled = "true";
            #         logLevel = "DEBUG";
            #         crowdsecLapiKeyFile = config.age.secrets.crowdsecApi.path;
            #         crowdsecMode = "live";
            #         crowdsecLapiHost = ":4223";
            #       };
            #     };
            #   };
            # };
          };
        };
      };
    };
  };
}
