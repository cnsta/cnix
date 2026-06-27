{
  config,
  lib,
  self,
  ...
}: let
  unit = "slskd";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
  arr = config.cnix.server.services.arr;
in {
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    age.secrets = {
      slskd.file = self + "/secrets/slskd.age";
    };

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "docker.io/slskd/slskd:latest";
        pull = "newer";
        autoStart = true;
        dependsOn = ["gluetun-slskd"];
        extraOptions = [
          "--network=container:gluetun-slskd"
          "--label=io.containers.autoupdate=registry"
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
