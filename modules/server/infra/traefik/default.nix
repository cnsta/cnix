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

  site = config.cnix.settings.site;
  localDomain = site.domains.local;
  publicDomain = site.domains.public;

  # trust boundaries
  loopback = ["127.0.0.1/32" "::1/128"];
  podman = [site.subnets.podman];
  lan = [site.subnets.lan];
  tailnet = [site.subnets.tailnet4 site.subnets.tailnet6];

  autheliaUp = srv.services.authelia.enable;

  accessLog = "/var/log/traefik/access.log";

  gateFor = service:
    if service.exposure == "local" && !(service.auth && autheliaUp)
    then "lan-only"
    else "private";

  middlewaresFor = service:
    lib.optional service.securityHeaders "security-headers"
    ++ lib.optional (service.exposure != "public") (gateFor service)
    ++ lib.optional (service.auth && autheliaUp) "authelia"
    ++ service.middlewares;

  routable = clib.server.routable config;

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
    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "traefik";
      description = "Dashboard name on the local domain.";
    };
  };

  config = mkIf cfg.enable {
    age.secrets.traefikEnv = {
      file = "${self}/secrets/traefikEnv.age";
      mode = "640";
      owner = "traefik";
      group = "traefik";
    };

    systemd.services.traefik.serviceConfig = {
      EnvironmentFile = [config.age.secrets.traefikEnv.path];
      LogsDirectory = "traefik";
      LogsDirectoryMode = "0750";
    };

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
          accesslog = {
            filepath = accessLog;
            format = "json";
          };
          api = {
            dashboard = true;
            insecure = false;
          };

          certificatesResolvers.letsencrypt.acme = {
            email = site.mail;
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
              http = {
                aliasHeadersStrategy = "delete";
                redirections.entryPoint = {
                  to = "websecure";
                  scheme = "https";
                  permanent = true;
                };
              };
            };

            websecure = {
              address = ":443";
              forwardedHeaders.trustedIPs = trustedProxies;
              transport.respondingTimeouts = {
                readTimeout = "0s";
                idleTimeout = "3600s";
              };
              http = {
                aliasHeadersStrategy = "delete";
                tls = {
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
                  ];
                };
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
              lan-only.ipAllowList.sourceRange = loopback ++ podman ++ lan;
              private.ipAllowList.sourceRange = loopback ++ podman ++ lan ++ tailnet;

              security-headers.headers = {
                stsSeconds = 31536000;
                stsIncludeSubdomains = true;
                stsPreload = false;
                contentTypeNosniff = true;
                browserXssFilter = true;
                referrerPolicy = "strict-origin-when-cross-origin";
                customFrameOptionsValue = "SAMEORIGIN";
              };
            };

            routers =
              generateRouters routable
              // {
                api = {
                  entryPoints = ["websecure"];
                  rule = "Host(`${cfg.subdomain}.${localDomain}`)";
                  service = "api@internal";
                  middlewares =
                    ["security-headers" "private"]
                    ++ lib.optional autheliaUp "authelia";
                  tls = {};
                };
              }
              // lib.mapAttrs' (name: s:
                lib.nameValuePair "${name}-local" {
                  entryPoints = ["websecure"];
                  rule = "Host(`${s.subdomain}.${localDomain}`)";
                  service = name;
                  middlewares = lib.optional s.securityHeaders "security-headers" ++ ["private"] ++ s.middlewares;
                  tls = {};
                }) (lib.filterAttrs (_: s: s.localAlias) routable);
          };
        };
      };
    };
  };
}
