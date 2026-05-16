{
  config,
  lib,
  self,
  ...
}:
let
  unit = "radarr";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
  arr = config.cnix.server.services.arr;
in
{
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    age.secrets = {
      radarrEnvironment.file = (self + "/secrets/radarrEnvironment.age");
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/radarr 0755 share share - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/hotio/radarr:latest";
        pull = "newer";
        autoStart = true;
        dependsOn = [ "gluetun-arr" ];
        extraOptions = [
          "--network=container:gluetun-arr"
          "--label=io.containers.autoupdate=registry"
        ];
        volumes = [
          "/var/lib/radarr:/config"
          "/mnt/data:/data"
        ];
        environmentFiles = [ config.age.secrets.radarrEnvironment.path ];
      };
    };
  };
}
