{
  config,
  lib,
  self,
  ...
}: let
  unit = "bazarr";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
  arr = config.cnix.server.services.arr;
in {
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    age.secrets = {
      bazarrEnvironment.file = self + "/secrets/bazarrEnvironment.age";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/bazarr 0755 share share - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/hotio/bazarr:latest";
        autoStart = true;
        dependsOn = ["gluetun-arr"];
        extraOptions = [
          "--network=container:gluetun-arr"
        ];
        volumes = [
          "/var/lib/bazarr:/config"
          "/mnt/data:/data"
        ];
        environmentFiles = [config.age.secrets.bazarrEnvironment.path];
      };
    };
  };
}
