{
  config,
  lib,
  self,
  ...
}:
let
  unit = "lidarr";
  srv = config.server;
  cfg = config.server.services.${unit};
  arr = config.server.services.arr;
in
{
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    age.secrets = {
      lidarrEnvironment.file = (self + "/secrets/lidarrEnvironment.age");
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/lidarr 0755 share share - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/hotio/lidarr:latest";
        autoStart = true;
        dependsOn = [ "gluetun-arr" ];
        extraOptions = [
          "--network=container:gluetun-arr"
        ];
        volumes = [
          "/var/lib/lidarr:/config"
          "/mnt/data:/data"
        ];
        environmentFiles = [ config.age.secrets.lidarrEnvironment.path ];
      };
    };
  };
}
