{
  config,
  lib,
  ...
}: let
  inherit (lib) elem filterAttrs mapAttrs mapAttrs' mapAttrsToList mkIf mkMerge mkOption nameValuePair types;

  cfg = config.cnix.server.infra.anubis;

  tunnelExposures = ["tunnel" "dedicated-tunnel"];

  gated =
    filterAttrs (_: svc: svc.enable && svc.anubis.port != null)
    config.cnix.server.services;
in {
  options.cnix.server.infra.anubis = {
    sites = mkOption {
      default = {};
      description = ''
        Public sites served through Anubis' proof-of-work challenge against scrapers:
        Traefik (no IP gate) -> Anubis -> target. Anubis reads the client address from
        Traefik's X-Real-Ip. Its default policy already lets /.well-known, robots.txt
        and favicons through, add rules for anything non-browser (feeds, git, APIs).
      '';
      type = types.attrsOf (types.submodule {
        options = {
          host = mkOption {
            type = types.str;
            example = "cnst.dev";
            description = "Hostname Traefik routes to this site.";
          };
          target = mkOption {
            type = types.str;
            example = "http://127.0.0.1:8283";
            description = "The backend Anubis protects.";
          };
          port = mkOption {
            type = types.port;
            description = "Loopback port Anubis listens on (Traefik can't proxy to unix sockets).";
          };
          extraBots = mkOption {
            type = types.listOf types.attrs;
            default = [];
            example = [
              {
                name = "feeds";
                path_regex = "^/(index\\.xml|feed\\.xml|rss\\.xml)$";
                action = "ALLOW";
              }
            ];
            description = "Extra policy rules, after Anubis' defaults.";
          };
          traefik = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Route `host` through Traefik to Anubis. Off for tunnel-fronted services,
              where cloudflared targets Anubis directly.
            '';
          };
          realIpHeader = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "Cf-Connecting-Ip";
            description = "Header holding the client address, when no proxy sets X-Real-Ip.";
          };
        };
      });
    };
  };

  config = mkMerge [
    {
      assertions =
        mapAttrsToList (name: svc: {
          assertion = elem svc.exposure tunnelExposures;
          message = ''
            cnix.server.services.${name}.anubis only gates Cloudflare tunnels, but its
            exposure is "${svc.exposure}".
          '';
        })
        gated;

      cnix.server.infra.anubis.sites =
        mapAttrs (_: svc: {
          host = "${svc.subdomain}.${config.cnix.server.infra.www.url}";
          target = "http://127.0.0.1:${toString svc.port}";
          inherit (svc.anubis) port extraBots;
          traefik = false;
          realIpHeader = "Cf-Connecting-Ip";
        })
        gated;
    }

    (mkIf (cfg.sites != {}) {
      services.anubis.instances =
        mapAttrs (_: site: {
          settings =
            {
              BIND_NETWORK = "tcp";
              BIND = "127.0.0.1:${toString site.port}";
              TARGET = site.target;
              OG_PASSTHROUGH = true;
            }
            // lib.optionalAttrs (site.realIpHeader != null) {
              CUSTOM_REAL_IP_HEADER = site.realIpHeader;
            };
          policy.extraBots = site.extraBots;
        })
        cfg.sites;

      services.traefik.dynamicConfigOptions.http = let
        routed = filterAttrs (_: site: site.traefik) cfg.sites;
      in {
        routers = mapAttrs' (name: site:
          nameValuePair "anubis-${name}" {
            entryPoints = ["websecure"];
            rule = "Host(`${site.host}`)";
            service = "anubis-${name}";
            middlewares = ["security-headers"];
            tls = {};
          })
        routed;

        services = mapAttrs' (name: site:
          nameValuePair "anubis-${name}" {
            loadBalancer.servers = [{url = "http://127.0.0.1:${toString site.port}";}];
          })
        routed;
      };
    })
  ];
}
