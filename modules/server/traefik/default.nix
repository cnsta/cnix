{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types;

  cfg = config.server.traefik;
  getCloudflareCredentials = hostname:
    if hostname == "ziggy"
    then config.age.secrets.cloudflareDnsCredentialsZiggy.path
    else if hostname == "sobotka"
    then config.age.secrets.cloudflareDnsCredentials.path
    else throw "Unknown hostname: ${hostname}";
in {
  options.server.traefik = {
    enable = mkEnableOption "Enable global Traefik reverse proxy with ACME";
  };

  config = mkIf cfg.enable {
    age.secrets.traefikEnv = {
      file = "${self}/secrets/traefikEnv.age";
      mode = "640";
      owner = "root";
      group = "traefik";
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

          tracing = {};
          api = {
            dashboard = true;
          };
          certificatesResolvers = {
            tailscale.tailscale = {};
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
            redis = {
              address = "0.0.0.0:6381";
            };
            postgres = {
              address = "0.0.0.0:5433";
            };
            web = {
              address = "0.0.0.0:80";
              http.redirections.entryPoint = {
                to = "websecure";
                scheme = "https";
                permanent = true;
              };
            };
            websecure = {
              address = "0.0.0.0:443";
              http.tls = {
                certResolver = "letsencrypt";
                domains = [
                  {
                    main = "cnix.dev";
                    sans = ["*.cnix.dev"];
                  }
                ];
              };
            };
          };
        };
      };
    };
  };
}
