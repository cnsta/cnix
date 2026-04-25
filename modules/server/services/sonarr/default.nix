{
  config,
  lib,
  self,
  ...
}:
let
  unit = "sonarr";
  srv = config.server;
  cfg = config.server.services.${unit};
  arr = config.server.services.arr;
in
{
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    age.secrets = {
      sonarrEnvironment.file = (self + "/secrets/sonarrEnvironment.age");
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/sonarr 0755 share share - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/hotio/sonarr:latest";
        autoStart = true;
        dependsOn = [ "gluetun-arr" ];
        extraOptions = [
          "--network=container:gluetun-arr"
        ];
        volumes = [
          "/var/lib/sonarr:/config"
          "/mnt/data:/data"
        ];
        environmentFiles = [ config.age.secrets.sonarrEnvironment.path ];
      };
    };
  };
}
