{
  config,
  lib,
  ...
}: let
  unit = "n8n";
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
      default = "n8n";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "A workflow automation platform";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "n8n.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      n8n = {
        enable = true;
        openFirewall = true;
      };

      traefik = {
        dynamicConfigOptions = {
          http = {
            services.n8n.loadBalancer.servers = [{url = "http://127.0.0.1:5678";}];
            routers = {
              n8n = {
                entryPoints = ["websecure"];
                rule = "Host(`${cfg.url}`)";
                service = "n8n";
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
