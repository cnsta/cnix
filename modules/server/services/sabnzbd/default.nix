{
  config,
  lib,
  self,
  ...
}:
let
  unit = "sabnzbd";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
  arr = config.cnix.server.services.arr;
in
{
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    age.secrets = {
      sabnzbdEnvironment.file = (self + "/secrets/sabnzbdEnvironment.age");
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/sabnzbd 0755 share share - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/hotio/sabnzbd:latest";
        autoStart = true;
        dependsOn = [ "gluetun-arr" ];
        extraOptions = [
          "--network=container:gluetun-arr"
        ];
        volumes = [
          "/var/lib/sabnzbd:/config:rw"
          "/mnt/data/downloads:/data:rw"
        ];
        environmentFiles = [ config.age.secrets.sabnzbdEnvironment.path ];
      };
    };
  };
}
