{
  config,
  lib,
  self,
  pkgs,
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

    # This is needed for LAN access
    networking.firewall = {
      allowedTCPPorts = [8096];
      allowedUDPPorts = [1900 7359];
    };

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/hotio/jellyfin:latest";
        autoStart = true;
        ports = ["${toString cfg.port}:8096"];
        volumes = [
          "/var/lib/jellyfin:/config"
          "/var/cache/jellyfin:/cache"
          "/mnt/data/media/series:/series:ro"
          "/mnt/data/media/films:/films:ro"
        ];
        extraOptions = [
          "--device=/dev/dri/renderD129"
          "--network=host"
        ];
        environmentFiles = [config.age.secrets.jellyfinEnvironment.path];
      };
    };

    environment.systemPackages = with pkgs; [
      jellyfin-ffmpeg
    ];
  };
}
