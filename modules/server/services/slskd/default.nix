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
        dependsOn = [ "gluetun-slskd" ];
        extraOptions = [
          "--network=container:gluetun-slskd"
        ];
        volumes = [
          "/var/lib/slskd:/app:rw"
          "/mnt/data/downloads:/downloads:rw"
          "/mnt/data/media/music:/music:rw"
        ];
        environmentFiles = [
          config.age.secrets.slskd.path
        ];
      };
    };
  };
}
