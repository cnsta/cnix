{
  config,
  lib,
  ...
}:
let
  unit = "qbittorrent";
  srv = config.server;
  cfg = config.server.services.${unit};
in
{
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/hotio/qbittorrent:latest";
        autoStart = true;
        dependsOn = [ "gluetun" ];
        ports = [
          "8080:8080"
          "58846:58846"
        ];
        extraOptions = [
          "--network=container:gluetun"
        ];
        volumes = [
          "/var/lib/qbittorrent:/config:rw"
          "/mnt/data/media/downloads:/downloads:rw"
        ];
        environment = {
          PUID = "994";
          PGID = "993";
          TZ = "Europe/Stockholm";
          WEBUI_PORT = "${builtins.toString cfg.port}";
        };
      };
    };
  };
}
