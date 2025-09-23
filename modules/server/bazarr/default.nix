{
  config,
  lib,
  ...
}: let
  unit = "bazarr";
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
      default = "Bazarr";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Subtitle manager";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "bazarr.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
  };
  config = lib.mkIf cfg.enable {
    services.${unit} = {
      enable = true;
      user = srv.user;
      group = srv.group;
    };
    services.traefik = {
      dynamicConfigOptions = {
        http = {
          services.bazarr.loadBalancer.servers = [{url = "http://127.0.0.1:${toString config.services.${unit}.listenPort}";}];
          routers = {
            bazarr = {
              entryPoints = ["websecure"];
              rule = "Host(`${cfg.url}`)";
              service = "bazarr";
              tls.certResolver = "letsencrypt";
              # middlewares = ["authentik"];
            };
          };
        };
      };
    };
  };
}
