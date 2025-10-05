{
  config,
  lib,
  pkgs,
  ...
}: let
  unit = "jellyfin";
  cfg = config.server.${unit};
  srv = config.server;
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
      default = "fin.${srv.tailscale.url}";
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
    services.${unit} = {
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
          services.${unit}.loadBalancer.servers = [{url = "http://localhost:8096";}];
          routers = {
            jellyfinRouter = {
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
