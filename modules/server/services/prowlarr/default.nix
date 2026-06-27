{
  config,
  lib,
  self,
  ...
}: let
  unit = "prowlarr";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
  arr = config.cnix.server.services.arr;
in {
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    age.secrets = {
      prowlarrEnvironment.file = self + "/secrets/prowlarrEnvironment.age";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/prowlarr 0755 share share - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/hotio/prowlarr:latest";
        autoStart = true;
        dependsOn = ["gluetun-arr"];
        extraOptions = [
          "--network=container:gluetun-arr"
        ];
        volumes = [
          "/var/lib/prowlarr:/config"
        ];
        environmentFiles = [config.age.secrets.prowlarrEnvironment.path];
      };
    };
  };
}
