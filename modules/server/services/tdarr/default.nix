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

  sharedVolumes = [
    "/mnt/data/media:/media"
    "/mnt/data/downloads:/downloads"
    "/var/lib/tdarr/configs:/app/configs"
    "/var/lib/tdarr/logs:/app/logs"
    "/var/lib/tdarr/server:/app/server"
    "/var/lib/tdarr/transcode_cache:/temp"
  ];
in
{
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    systemd.tmpfiles.rules = [
      "d /var/lib/tdarr/transcode_cache 0755 root root - -"
      "d /var/lib/tdarr/configs          0755 root root - -"
      "d /var/lib/tdarr/logs             0755 root root - -"
      "d /var/lib/tdarr/server           0755 root root - -"
    ];

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
          TZ = "Europe/Stockholm";
          PUID = "0";
          PGID = "0";
        };
        ports = [
          "8265:8265"
          "8266:8266"
        ];
        volumes = sharedVolumes;
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
          PUID = "0";
          PGID = "0";
        };
        ports = [
          "8267:8267"
        ];
        devices = [
          "/dev/dri/card1:/dev/dri/card1"
          "/dev/dri/renderD129:/dev/dri/renderD129"
        ];
        volumes = sharedVolumes;
      };
    };
  };
}
