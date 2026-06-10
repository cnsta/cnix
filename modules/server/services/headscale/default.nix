{
  config,
  lib,
  clib,
  self,
  pkgs,
  ...
}:
let
  unit = "headscale";
  cfg = config.cnix.server.services.${unit};
  srv = config.cnix.server;
  domain = clib.server.mkHostDomain config cfg;
  fqdn = "${cfg.subdomain}.${domain}";

  autheliaUrl = "https://login.${srv.domain}";

  headplanePort = 3004;

  headplaneConfig = (pkgs.formats.yaml { }).generate "headplane-config.yaml" {
    server = {
      host = "127.0.0.1";
      port = headplanePort;
      base_url = "https://${fqdn}";
      cookie_secure = true;
      cookie_max_age = 86400;
      cookie_secret = "00000000000000000000000000000000";
      data_path = "/var/lib/headplane";
    };
    headscale = {
      url = "http://127.0.0.1:${toString cfg.port}";
      public_url = "https://${fqdn}";
      config_path = "/etc/headscale/config.yaml";
      config_strict = false;
    };
    integration = {
      agent.enabled = false;
      docker.enabled = false;
      kubernetes.enabled = false;
      proc.enabled = false;
    };
    oidc = {
      issuer = autheliaUrl;
      client_id = unit;
      use_pkce = true;
      token_endpoint_auth_method = "client_secret_basic";
      disable_api_key_login = false;
    };
  };
in
{
  config = lib.mkIf (cfg.enable && srv.infra.podman.enable) {
    age.secrets = {
      headscaleOidc = {
        owner = unit;
        group = "users";
        file = "${self}/secrets/headscaleOidc.age";
      };
      headplaneEnv.file = "${self}/secrets/headplaneEnv.age";
    };

    services.${unit} = {
      enable = true;
      address = "127.0.0.1";
      port = cfg.port;
      settings = {
        server_url = "https://${fqdn}";

        database = {
          type = "sqlite";
          sqlite = {
            path = "/var/lib/headscale/db.sqlite";
            write_ahead_log = true;
          };
        };

        prefixes = {
          v4 = "100.64.0.0/10";
          v6 = "fd7a:115c:a1e0::/48";
          allocation = "sequential";
        };

        derp = {
          urls = [ "https://controlplane.tailscale.com/derpmap/default" ];
          auto_update_enabled = true;
          update_frequency = "24h";
        };

        dns = {
          magic_dns = true;
          base_domain = "ts.cnst.dev";
          nameservers.global = [ "192.168.88.69" ];
          search_domains = [ ];
        };

        policy.mode = "database";

        oidc = {
          issuer = autheliaUrl;
          client_id = unit;
          client_secret_path = config.age.secrets.headscaleOidc.path;
          scope = [
            "openid"
            "profile"
            "email"
            "groups"
          ];
          pkce = {
            enabled = true;
            method = "S256";
          };
        };

        log.level = "info";
      };
    };

    virtualisation.oci-containers.containers.headplane = {
      autoStart = true;
      image = "ghcr.io/tale/headplane:latest";
      volumes = [
        "${headplaneConfig}:/etc/headplane/config.yaml:ro"
        "/var/lib/headplane:/var/lib/headplane"
        "/etc/headscale/config.yaml:/etc/headscale/config.yaml:ro"
      ];
      environment = {
        TZ = "Europe/Stockholm";
        HEADPLANE_LOAD_ENV_OVERRIDES = "true";
      };
      environmentFiles = [ config.age.secrets.headplaneEnv.path ];
      extraOptions = [ "--network=host" ];
    };

    systemd = {
      tmpfiles.rules = [ "d /var/lib/headplane 0750 root root -" ];
      services."podman-headplane" = {
        after = [ "headscale.service" ];
        requires = [ "headscale.service" ];
      };
    };

    services.traefik.dynamicConfigOptions.http = {
      routers = {
        headscale.middlewares = [ "headscale-cors" ];

        headplane = {
          entryPoints = [ "websecure" ];
          rule = "Host(`${fqdn}`) && PathPrefix(`/admin`)";
          service = "headplane";
          tls.certResolver = "letsencrypt";
        };

        headscale-root = {
          entryPoints = [ "websecure" ];
          rule = "Host(`${fqdn}`) && Path(`/`)";
          service = unit;
          middlewares = [ "headscale-rewrite" ];
          tls.certResolver = "letsencrypt";
        };
      };

      services.headplane.loadBalancer.servers = [
        { url = "http://127.0.0.1:${toString headplanePort}"; }
      ];

      middlewares = {
        headscale-rewrite.addPrefix.prefix = "/admin";
        headscale-cors.headers = {
          accessControlAllowHeaders = [ "*" ];
          accessControlAllowMethods = [
            "GET"
            "POST"
            "PUT"
          ];
          accessControlAllowOriginList = [ "https://${fqdn}" ];
          accessControlMaxAge = 100;
          addVaryHeader = true;
        };
      };
    };
  };
}
