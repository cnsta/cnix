{
  config,
  lib,
  ...
}: let
  unit = "jellyseerr";
  srv = config.server;
  cfg = config.server.${unit};
in {
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      # default = "seer.${srv.tailscale.url}";
      default = "jellyseerr.${srv.domain}";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Jellyseerr";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Media request and discovery manager";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "jellyseerr.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
  };
  config = lib.mkIf cfg.enable {
    services.${unit} = {
      enable = true;
      port = cfg.port;
    };
    services.traefik = {
      dynamicConfigOptions = {
        http = {
          services.jellyseerr.loadBalancer.servers = [{url = "http://localhost:${toString cfg.port}";}];
          routers = {
            jellyseerr = {
              entryPoints = ["websecure"];
              rule = "Host(`${cfg.url}`)";
              service = "${unit}";
              tls.certResolver = "letsencrypt";
            };
          };
        };
      };
    };
  };
}
