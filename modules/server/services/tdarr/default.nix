{
  config,
  lib,
  ...
}: let
  unit = "tdarr";
  srv = config.server;
  cfg = config.server.services.${unit};
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/haveagitgat/tdarr:latest";
        autoStart = true;
        environment = {
          serverIP = "0.0.0.0";
          serverPort = "8266";
          webUIPort = "8265";
          nodeName = "sobotkaNode";
          internalNode = "true";
          inContainer = "true";
          ffmpegVersion = "7";
          auth = "false";
          maxLogSizeMB = "10";
          PUID = "994";
          PGID = "993";
          TZ = "Europe/Stockholm";
        };
        devices = ["/dev/dri:/dev/dri"];
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
        extraOptions = [
          "--memory=5g"
        ];
      };
    };
  };
}
