{
  lib,
  clib,
  config,
  self,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cnix.server.infra.traefik;
  srv = config.cnix.server;

  localDomain = config.cnix.settings.accounts.domains.local;
  publicDomain = config.cnix.settings.accounts.domains.public;

  # trust boundaries
  loopback = ["127.0.0.1/32" "::1/128"];
  podman = ["10.88.0.0/24"];
  lan = ["192.168.88.0/24"];
  tailnet = ["100.64.88.0/24" "fd7a:115c:a1e0:88::/64"];

  autheliaUp = srv.services.authelia.enable;

  accessLog = "/var/lib/traefik/logs/access.log";

  gateFor = service:
    if service.exposure == "tailscale"
    then "tailnet-only"
    else "lan-only";

  middlewaresFor = service:
    ["security-headers" (gateFor service)]
    ++ lib.optional (service.auth && autheliaUp) "authelia"
    ++ service.middlewares;

  routable =
    lib.filterAttrs
    (_: s: s.enable && s.routed && s.subdomain != "")
    srv.services;

  generateRouters = services:
    lib.mapAttrs (name: service: {
      entryPoints = ["websecure"];
      rule = "Host(`${clib.server.mkFullDomain config service}`)";
      service = name;
      middlewares = middlewaresFor service;
      tls = {};
    })
    services;

  generateServices = services:
    lib.mapAttrs (_: service: {
      loadBalancer.servers = [{url = "http://localhost:${toString service.port}";}];
    })
    services;
in {
  options.cnix.server.infra.traefik = {
    enable = mkEnableOption "Enable global Traefik reverse proxy with ACME";
  };

  config = mkIf cfg.enable {
    age.secrets.traefikEnv = {
      file = "${self}/secrets/traefikEnv.age";
      mode = "640";
      owner = "traefik";
      group = "traefik";
    };

    systemd.services.traefik.serviceConfig.EnvironmentFile = [
      config.age.secrets.traefikEnv.path
    ];

    networking.firewall.allowedTCPPorts = [80 443];

    services.logrotate.settings.traefik-access = {
      files = accessLog;
      su = "traefik traefik";
      create = "0640 traefik traefik";
      rotate = 7;
      frequency = "daily";
      compress = true;
      delaycompress = true;
      missingok = true;
      notifempty = true;
      postrotate = "systemctl kill -s USR1 traefik.service";
    };

    services = {
      tailscale.permitCertUid = "traefik";

      traefik = {
        enable = true;

        staticConfigOptions = {
          log.level = "INFO";
          accesslog.filepath = accessLog;
          api = {
            dashboard = true;
            insecure = false;
          };

          certificatesResolvers.letsencrypt.acme = {
            email = srv.email;
            storage = "/var/lib/traefik/cert.json";
            dnsChallenge = {
              provider = "cloudflare";
              resolvers = ["1.1.1.1:53" "1.0.0.1:53"];
            };
          };

          entryPoints = let
            trustedProxies = loopback ++ podman;
          in {
            web = {
              address = ":80";
              forwardedHeaders.trustedIPs = trustedProxies;
              http.redirections.entryPoint = {
                to = "websecure";
                scheme = "https";
                permanent = true;
              };
            };

            websecure = {
              address = ":443";
              forwardedHeaders.trustedIPs = trustedProxies;
              http.tls = {
                certResolver = "letsencrypt";
                domains = [
                  {
                    main = localDomain;
                    sans = ["*.${localDomain}"];
                  }
                  {
                    main = publicDomain;
                    sans = ["*.${publicDomain}"];
                  }
                  {
                    main = "ts.${publicDomain}";
                    sans = ["*.ts.${publicDomain}"];
                  }
                ];
              };
            };
          };
        };

        dynamicConfigOptions = {
          tls.options.default = {
            minVersion = "VersionTLS12";
            sniStrict = true;
          };

          http = {
            services = generateServices routable;

            middlewares = {
              lan-only.ipAllowList.sourceRange = loopback ++ podman ++ lan ++ tailnet;
              tailnet-only.ipAllowList.sourceRange = loopback ++ tailnet;

              security-headers.headers = {
                stsSeconds = 31536000;
                stsIncludeSubdomains = true;
                stsPreload = false;
                contentTypeNosniff = true;
                browserXssFilter = true;
                referrerPolicy = "strict-origin-when-cross-origin";
                frameDeny = true;
              };
            };

            routers =
              generateRouters routable
              // {
                api = {
                  entryPoints = ["websecure"];
                  rule = "Host(`traefik.${localDomain}`)";
                  service = "api@internal";
                  middlewares =
                    ["security-headers" "lan-only"]
                    ++ lib.optional autheliaUp "authelia";
                  tls = {};
                };
              }
              // lib.optionalAttrs autheliaUp {
                authelia-local = {
                  entryPoints = ["websecure"];
                  rule = "Host(`login.${localDomain}`)";
                  service = "authelia";
                  middlewares = ["security-headers" "lan-only"];
                  tls = {};
                };
              };
          };
        };
      };
    };
  };
}
