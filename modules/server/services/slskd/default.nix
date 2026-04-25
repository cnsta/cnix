{
  config,
  lib,
  self,
  ...
}:
let
  unit = "slskd";
  srv = config.server;
  cfg = config.server.services.${unit};
  arr = config.server.services.arr;
in
{
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    age.secrets = {
      slskd.file = (self + "/secrets/slskd.age");
    };

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "slskd/slskd:latest";
        autoStart = true;
        dependsOn = [ "gluetun" ];
        extraOptions = [
          "--network=container:gluetun"
        ];
        volumes = [
          "/var/lib/slskd:/app:rw"
          "/mnt/data/downloads:/downloads:rw"
        ];
        environmentFiles = [
          config.age.secrets.slskd.path
        ];
        environment = {
          TZ = "Europe/Stockholm";
          PUID = srv.user;
          PGID = srv.group;
          SLSKD_REMOTE_CONFIGURATION = "true";
          SLSKD_REMOTE_FILE_MANAGEMENT = "true";
          SLSKD_DOWNLOADS_DIR = "/downloads";
          SLSKD_UMASK = "022";
        };
      };
    };
  };
}
