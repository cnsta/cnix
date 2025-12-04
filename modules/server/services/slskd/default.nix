{
  config,
  lib,
  self,
  ...
}: let
  unit = "slskd";
  srv = config.server;
  cfg = config.server.services.${unit};
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      slskd.file = "${self}/secrets/slskd.age";
    };
    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "slskd/slskd:latest";
        autoStart = true;
        dependsOn = ["gluetun"];
        ports = [
          "5030:5030"
          "5031:5031"
          "50300:50300"
        ];
        extraOptions = [
          "--network=container:gluetun"
        ];
        volumes = [
          "/var/lib/slskd:/app:rw"
          "/mnt/data/media/downloads:/downloads:rw"
        ];
        environmentFiles = [
          config.age.secrets.slskd.path
        ];
        environment = {
          TZ = "Europe/Stockholm";
          PUID = "981";
          PGID = "982";
          SLSKD_REMOTE_CONFIGURATION = "true";
          SLSKD_REMOTE_FILE_MANAGEMENT = "true";
          SLSKD_DOWNLOADS_DIR = "/downloads";
          SLSKD_UMASK = "022";
        };
      };
    };
  };
}
