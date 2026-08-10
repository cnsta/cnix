{
  config,
  lib,
  ...
}: let
  unit = "music-assistant";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    systemd.tmpfiles.rules = ["d /var/lib/music-assistant 0775 ${srv.user} ${srv.group} - -"];
    networking.firewall = {
      allowedTCPPorts = [8095 8097];
      allowedUDPPorts = [1900 5353];
    };
    virtualisation.oci-containers.containers = {
      ${unit} = {
        autoStart = true;
        image = "ghcr.io/music-assistant/server:latest";
        volumes = [
          "/var/lib/music-assistant:/data"
          "/mnt/data/media/music:/media:ro"
        ];
        environment = {
          TZ = "Europe/Stockholm";
          PUID = toString config.users.users.${srv.user}.uid;
          PGID = toString config.users.groups.${srv.group}.gid;
        };
        extraOptions = [
          "--network=host"
        ];
      };
    };
  };
}
