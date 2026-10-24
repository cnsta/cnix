{
  config,
  lib,
  self,
  ...
}: let
  unit = "dispatcharr";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      dispatcharrEnvironment.file = self + "/secrets/dispatcharrEnvironment.age";
    };

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/dispatcharr/dispatcharr:latest";
        autoStart = true;
        volumes = [
          "/var/lib/dispatcharr:/data"
        ];
        dependsOn = [
          "gluetun-dispatcharr"
        ];

        extraOptions = [
          "--network=container:gluetun-dispatcharr"
          "--device=/dev/dri/renderD129:/dev/dri/renderD128"
        ];
        environmentFiles = [config.age.secrets.dispatcharrEnvironment.path];
      };
    };
  };
}
