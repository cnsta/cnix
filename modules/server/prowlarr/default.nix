{
  config,
  lib,
  ...
}: let
  unit = "prowlarr";
  srv = config.server;
  cfg = config.server.${unit};
in {
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/${unit}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "${unit}.${srv.domain}";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Prowlarr";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "PVR indexer";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "prowlarr.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      ${unit} = {
        enable = true;
      };
      flaresolverr = {
        enable = true;
      };

      traefik = {
        dynamicConfigOptions = {
          http = {
            services = {
              prowlarr = {
                loadBalancer.servers = [{url = "http://127.0.0.1:9696";}];
              };
              flaresolverr = {
                loadBalancer.servers = [{url = "http://127.0.0.1:8191";}];
              };
            };
            routers = {
              prowlarr = {
                entryPoints = ["websecure"];
                rule = "Host(`${cfg.url}`)";
                service = "prowlarr";
                tls.certResolver = "letsencrypt";
                # middlewares = ["authentik"];
              };
              flaresolverr = {
                entryPoints = ["websecure"];
                rule = "Host(`flaresolverr.${srv.domain}`)";
                service = "flaresolverr";
                tls.certResolver = "letsencrypt";
                # middlewares = ["authentik"];
              };
            };
          };
        };
      };
    };
  };
}
