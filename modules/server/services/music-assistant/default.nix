{
  config,
  clib,
  lib,
  ...
}: let
  unit = "music-assistant";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    systemd.tmpfiles.rules = ["d ${cfg.configDir} 0775 ${srv.user} ${srv.group} - -"];
    networking.firewall = {
      allowedTCPPorts = [cfg.port 8097];
      allowedUDPPorts = [1900 5353];
    };
    virtualisation.oci-containers.containers = {
      ${unit} = {
        autoStart = true;
        image = "ghcr.io/music-assistant/server:latest";
        volumes = [
          "${cfg.configDir}:/data"
          "/mnt/data/media/music:/media:ro"
        ];
        environment = {
          inherit (clib.server.containerEnv config) TZ PUID PGID;
        };
        extraOptions = [
          "--network=host"
        ];
      };
    };
  };
}
