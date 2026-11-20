{
  config,
  lib,
  ...
}: let
  unit = "aurral";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    systemd.tmpfiles.rules = [
      "d /var/lib/aurral 0755 share share - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/lklynet/aurral:latest";
        autoStart = true;
        ports = ["127.0.0.1:${toString cfg.port}:3001"];
        environment = {
          TZ = "Europe/Stockholm";
          PUID = toString config.users.users.${srv.user}.uid;
          PGID = toString config.users.groups.${srv.group}.gid;
          BRAINZMASH_BASE_URL = "https://api.lidarr.audio/api/v0.4";
        };
        volumes = [
          "/var/lib/aurral:/config:rw"
          "/mnt/data/media/music:/data/media/music:rw"
          "/mnt/data/downloads:/data/downloads:rw"
        ];
      };
    };
  };
}
