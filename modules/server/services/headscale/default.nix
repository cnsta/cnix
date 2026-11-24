{
  config,
  lib,
  clib,
  self,
  pkgs,
  ...
}: let
  unit = "headscale";
  cfg = config.cnix.server.services.${unit};
  srv = config.cnix.server;
  domain = clib.server.mkDomain config cfg;
  fqdn = "${cfg.subdomain}.${domain}";

  autheliaUrl = clib.server.autheliaUrl config cfg;

  headplanePort = 3005;

  tailnet = srv.tailnet;

  autheliaUp = srv.services.authelia.enable;
  site = config.cnix.settings.site;
  tailnetServices =
    lib.filterAttrs (
      _: s: !(s.exposure == "local" && !(s.auth && autheliaUp))
    )
    (clib.server.routable config);

  tailnetNames =
    lib.mapAttrsToList (_: clib.server.mkFullDomain config) tailnetServices
    ++ lib.concatLists (lib.mapAttrsToList (
        _: s: map (sub: "${sub}.${clib.server.mkDomain config s}") (lib.attrNames s.ingress)
      )
      tailnetServices)
    ++ clib.server.localAliases config
    ++ lib.optional srv.infra.www.enable srv.infra.www.url;

  policy = pkgs.writeText "headscale-policy.json" (builtins.toJSON {
    groups = lib.mapAttrs' (g: users: lib.nameValuePair "group:${g}" users) tailnet.groups;
    hosts.server = "${tailnet.ip}/32";
    acls =
      lib.optional (tailnet.groups ? admins) {
        action = "accept";
        src = ["group:admins"];
        dst = ["*:*" "autogroup:internet:*"];
      }
      ++ lib.mapAttrsToList (g: _: {
        action = "accept";
        src = ["group:${g}"];
        dst = ["server:53,443" "autogroup:internet:*"];
      }) (removeAttrs tailnet.groups ["admins"]);
  });

  headplaneConfig = (pkgs.formats.yaml {}).generate "headplane-config.yaml" {
    server = {
      host = "127.0.0.1";
      port = headplanePort;
      base_url = "https://${fqdn}";
      cookie_secure = true;
      cookie_max_age = 86400;
      data_path = "/var/lib/headplane";
    };
    headscale = {
      url = "http://127.0.0.1:${toString cfg.port}";
      public_url = "https://${fqdn}";
      config_path = "/etc/headscale/config.yaml";
      config_strict = true;
    };
    integration = {
      agent = {
        enabled = false;
        pre_authkey = "unused";
        host_name = "headplane-agent";
      };
      docker.enabled = false;
      kubernetes = {
        enabled = false;
        validate_manifest = true;
        pod_name = "headscale";
      };
      proc.enabled = false;
    };
    oidc = {
      issuer = autheliaUrl;
      client_id = unit;
      use_pkce = true;
      token_endpoint_auth_method = "client_secret_basic";
      disable_api_key_login = true;
    };
  };
in {
  config = lib.mkIf (cfg.enable && srv.infra.podman.enable) {
    assertions = [
      {
        assertion = srv.publicIp != null;
        message = "cnix.server.publicIp must be set: tailnet clients resolve ${fqdn} to it (the tailnet IP deadlocks them after a server restart).";
      }
    ];

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
        metrics_listen_addr = "127.0.0.1:9091";

        database = {
          type = "sqlite";
          sqlite = {
            path = "/var/lib/headscale/db.sqlite";
            write_ahead_log = true;
          };
        };

        prefixes = {
          v4 = site.subnets.tailnet4;
          v6 = site.subnets.tailnet6;
          allocation = "sequential";
        };

        derp = {
          urls = ["https://controlplane.tailscale.com/derpmap/default"];
          auto_update_enabled = true;
          update_frequency = "24h";
        };

        dns = {
          magic_dns = true;
          base_domain = "cnst.internal";
          nameservers.global = [tailnet.ip];
          search_domains = [];
          extra_records =
            map (name: {
              type = "A";
              inherit name;
              value =
                if name == fqdn
                then srv.publicIp
                else tailnet.ip;
            })
            tailnetNames;
        };

        policy = {
          mode = "file";
          path = policy;
        };

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

        log.level = "warn";
      };
    };

    virtualisation.oci-containers.containers.headplane = {
      autoStart = true;
      image = "ghcr.io/tale/headplane:latest";
      volumes = [
        "${headplaneConfig}:/etc/headplane/config.yaml:ro"
        "/var/lib/headplane:/var/lib/headplane"
        "${config.services.headscale.configFile}:/etc/headscale/config.yaml:ro"
      ];
      environment = {
        TZ = config.cnix.server.timeZone;
      };
      environmentFiles = [config.age.secrets.headplaneEnv.path];
      extraOptions = ["--network=host"];
    };

    systemd = {
      tmpfiles.rules = ["d /var/lib/headplane 0750 root root -"];
      services = {
        "headscale" = {
          after = [
            "traefik.service"
            "authelia-main.service"
          ];
          wants = [
            "traefik.service"
            "authelia-main.service"
          ];
        };

        "podman-headplane" = {
          after = ["headscale.service"];
          requires = ["headscale.service"];
        };
      };
    };

    services.traefik.dynamicConfigOptions.http = {
      routers = {
        headplane = {
          entryPoints = ["websecure"];
          rule = "Host(`${fqdn}`) && PathPrefix(`/admin`)";
          service = "headplane";
          middlewares = ["security-headers" "private"];
          tls.certResolver = "letsencrypt";
        };

        headscale-root = {
          entryPoints = ["websecure"];
          rule = "Host(`${fqdn}`) && Path(`/`)";
          service = unit;
          middlewares = ["security-headers" "private" "headscale-rewrite"];
          tls.certResolver = "letsencrypt";
        };
      };

      services.headplane.loadBalancer.servers = [
        {url = "http://127.0.0.1:${toString headplanePort}";}
      ];

      middlewares = {
        headscale-rewrite.addPrefix.prefix = "/admin";
        headscale-cors.headers = {
          accessControlAllowHeaders = ["*"];
          accessControlAllowMethods = [
            "GET"
            "POST"
            "PUT"
          ];
          accessControlAllowOriginList = ["https://${fqdn}"];
          accessControlMaxAge = 100;
          addVaryHeader = true;
        };
      };
    };
  };
}
