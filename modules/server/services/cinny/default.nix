{
  config,
  lib,
  self,
  ...
}:
let
  unit = "cinny";
  srv = config.server;
  cfg = config.server.services.${unit};
in
{
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      cinnyJson = {
        file = (self + "/secrets/cinnyJson.age");
        mode = "0444";
      };
    };

    virtualisation.oci-containers.containers.cinny = {
      image = "ajbura/cinny:latest";
      ports = [ "${toString cfg.port}:80" ];
      autoStart = true;
      volumes = [
        "${config.age.secrets.cinnyJson.path}:/app/config.json:ro"
      ];
    };
  };
}
