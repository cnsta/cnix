{
  config,
  lib,
  self,
  ...
}: let
  unit = "sportarr";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
  arr = config.cnix.server.services.arr;
in {
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    age.secrets = {
      sportarrEnvironment.file = self + "/secrets/sportarrEnvironment.age";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/sportarr 0755 share share - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "sportarr/sportarr:latest";
        autoStart = true;
        dependsOn = ["gluetun-arr"];
        extraOptions = [
          "--network=container:gluetun-arr"
        ];
        volumes = [
          "/var/lib/sportarr:/config"
          "/mnt/data:/data"
        ];
        environmentFiles = [config.age.secrets.sportarrEnvironment.path];
      };
    };
  };
}
