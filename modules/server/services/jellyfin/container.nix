{
  config,
  lib,
  self,
  ...
}: let
  unit = "jellyfin";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      jellyfinEnvironment.file = self + "/secrets/jellyfinEnvironment.age";
    };

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/hotio/jellyfin:latest";
        autoStart = true;
        volumes = [
          "/var/lib/jellyfin:/config"
          "/var/cache/jellyfin/cache:/cache"
          "/var/cache/jellyfin/metadata:/metadata"
          "/mnt/data/media/series:/series:ro"
          "/mnt/data/media/films:/films:ro"
        ];
        extraOptions = [
          "--device=/dev/dri/renderD129"
        ];
        environmentFiles = [config.age.secrets.jellyfinEnvironment.path];
      };
    };
  };
}
