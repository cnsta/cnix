{
  config,
  lib,
  pkgs,
  ...
}: let
  service = "jellyfin";
  cfg = config.server.${service};
  srv = config.server;
in {
  options.server.${service} = {
    enable = lib.mkEnableOption {
      description = "Enable ${service}";
    };
    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/${service}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin.${srv.domain}";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Jellyfin";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "The Free Software Media System";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
  };
  config = lib.mkIf cfg.enable {
    services.${service} = {
      enable = true;
      user = srv.user;
      group = srv.group;
    };
    environment.systemPackages = with pkgs; [
      jellyfin-ffmpeg
    ];
    services.traefik = {
      dynamicConfigOptions = {
        http = {
          services.jellyfin.loadBalancer.servers = [{url = "http://127.0.0.1:8096";}];
          routers = {
            jellyfin = {
              entryPoints = ["websecure"];
              rule = "Host(`${cfg.url}`)";
              service = "jellyfin";
              tls.certResolver = "letsencrypt";
              # middlewares = ["authentik"];
            };
          };
        };
      };
    };
  };
}
