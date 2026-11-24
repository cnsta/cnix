{
  config,
  lib,
  ...
}: let
  unit = "tdarr";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};

  sharedVolumes = [
    "/mnt/data/media:/media"
    "/mnt/data/downloads:/downloads"
    "${cfg.configDir}/configs:/app/configs"
    "${cfg.configDir}/logs:/app/logs"
    "${cfg.configDir}/server:/app/server"
    "${cfg.configDir}/transcode_cache:/temp"
  ];
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    systemd.tmpfiles.rules = [
      "d ${cfg.configDir}/transcode_cache 0755 root root - -"
      "d ${cfg.configDir}/configs          0755 root root - -"
      "d ${cfg.configDir}/logs             0755 root root - -"
      "d ${cfg.configDir}/server           0755 root root - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/haveagitgat/tdarr:latest";
        autoStart = true;
        environment = {
          serverIP = "0.0.0.0";
          serverPort = "8266";
          webUIPort = toString cfg.port;
          inContainer = "true";
          ffmpegVersion = "7";
          auth = "false";
          maxLogSizeMB = "10";
          TZ = config.cnix.server.timeZone;
          PUID = "0";
          PGID = "0";
        };
        ports = ["127.0.0.1:${toString cfg.port}:${toString cfg.port}"];
        volumes = sharedVolumes;
      };

      node0 = {
        image = "ghcr.io/haveagitgat/tdarr_node:latest";
        autoStart = true;
        environment = {
          serverIP = "127.0.0.1";
          serverPort = "8266";
          nodeIP = "0.0.0.0";
          nodeID = "node0";
          TZ = config.cnix.server.timeZone;
          PUID = "0";
          PGID = "0";
        };
        dependsOn = [unit];
        extraOptions = ["--network=container:${unit}"];
        devices = [
          "/dev/dri/card1:/dev/dri/card1"
          "/dev/dri/renderD129:/dev/dri/renderD129"
        ];
        volumes = sharedVolumes;
      };
    };
  };
}
