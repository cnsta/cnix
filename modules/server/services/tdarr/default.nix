{
  config,
  lib,
  ...
}:
let
  unit = "tdarr";
  srv = config.server;
  cfg = config.server.services.${unit};
  arr = config.server.services.arr;
in
{
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/haveagitgat/tdarr:latest";
        autoStart = true;
        environment = {
          serverIP = "0.0.0.0";
          serverPort = "8266";
          webUIPort = "8265";
          inContainer = "true";
          ffmpegVersion = "7";
          auth = "false";
          maxLogSizeMB = "10";
          PUID = "994";
          PGID = "993";
          TZ = "Europe/Stockholm";
        };
        ports = [
          "8265:8265"
          "8266:8266"
        ];
        volumes = [
          "/mnt/data/media:/media"
          "/var/lib/tdarr/configs:/app/configs"
          "/var/lib/tdarr/logs:/app/logs"
          "/var/lib/tdarr/server:/app/server"
          "/var/lib/tdarr/transcode_cache:/temp"
        ];
      };
      node0 = {
        image = "kfalabs/tdarr-battlemage:latest";
        autoStart = true;
        environment = {
          serverIP = "host.containers.internal";
          serverPort = "8266";
          nodeIP = "0.0.0.0";
          nodeID = "node0";
          TZ = "Europe/Stockholm";
        };
        ports = [
          "8267:8267"
        ];
        devices = [
          "/dev/dri/card1:/dev/dri/card1"
          "/dev/dri/renderD129:/dev/dri/renderD129"
        ];
        volumes = [
          "/mnt/data/media:/media"
          "/var/lib/tdarr/configs:/app/configs"
          "/var/lib/tdarr/logs:/app/logs"
          "/var/lib/tdarr/server:/app/server"
          "/var/lib/tdarr/transcode_cache:/temp"
        ];
      };
    };
  };
}
