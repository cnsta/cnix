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
          "${cfg.configDir}:/data"
        ];
        dependsOn = ["gluetun-${cfg.vpn}"];

        extraOptions = [
          "--network=container:gluetun-${cfg.vpn}"
          "--device=/dev/dri/renderD129:/dev/dri/renderD128"
        ];
        environmentFiles = [config.age.secrets.dispatcharrEnvironment.path];
      };
    };
  };
}
