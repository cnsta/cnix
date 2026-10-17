{
  config,
  lib,
  ...
}: let
  inherit (lib) mapAttrs mapAttrs' mkIf mkOption nameValuePair types;

  cfg = config.cnix.server.infra.anubis;
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
        };
      });
    };
  };

  config = mkIf (cfg.sites != {}) {
    services.anubis.instances =
      mapAttrs (_: site: {
        settings = {
          BIND_NETWORK = "tcp";
          BIND = "127.0.0.1:${toString site.port}";
          TARGET = site.target;
          # Link previews (chat apps, socials) without exempting each bot.
          OG_PASSTHROUGH = true;
        };
        policy.extraBots = site.extraBots;
      })
      cfg.sites;

    services.traefik.dynamicConfigOptions.http = {
      routers = mapAttrs' (name: site:
        nameValuePair "anubis-${name}" {
          entryPoints = ["websecure"];
          rule = "Host(`${site.host}`)";
          service = "anubis-${name}";
          middlewares = ["security-headers"];
          tls = {};
        })
      cfg.sites;

      services = mapAttrs' (name: site:
        nameValuePair "anubis-${name}" {
          loadBalancer.servers = [{url = "http://127.0.0.1:${toString site.port}";}];
        })
      cfg.sites;
    };
  };
}
