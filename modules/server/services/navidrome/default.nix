{
  config,
  lib,
  ...
}:
let
  unit = "navidrome";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
in
{
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "docker.io/deluan/navidrome:latest";
        pull = "newer";
        autoStart = true;
        ports = [
          "${toString cfg.port}:${toString cfg.port}"
        ];
        extraOptions = [
          "--label=io.containers.autoupdate=registry"
        ];
        volumes = [
          "/mnt/data:/data"
          "/mnt/data/media/music:/music:ro"
        ];
      };
    };
  };
}
