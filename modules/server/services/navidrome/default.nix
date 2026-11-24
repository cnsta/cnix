{
  config,
  lib,
  ...
}: let
  unit = "navidrome";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    networking.firewall = {
      allowedTCPPorts = [cfg.port];
    };

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "docker.io/deluan/navidrome:latest";
        autoStart = true;
        ports = ["${toString cfg.port}:4533"];
        volumes = [
          "/mnt/data:/data"
          "/mnt/data/media/music:/music:ro"
        ];
        extraOptions = [
          "--network=host"
        ];
      };
    };
  };
}
