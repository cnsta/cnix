{
  config,
  lib,
  ...
}: let
  unit = "home-assistant";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    systemd.tmpfiles.rules = ["d /var/lib/home-assistant 0775 ${srv.user} ${srv.group} - -"];
    virtualisation.oci-containers.containers = {
      ${unit} = {
        autoStart = true;
        image = "docker.io/homeassistant/home-assistant:stable";
        volumes = [
          "/var/lib/home-assistant:/config"
          "/run/dbus:/run/dbus:ro"
        ];
        environment = {
          TZ = "Europe/Stockholm";
          PUID = toString config.users.users.${srv.user}.uid;
          PGID = toString config.users.groups.${srv.group}.gid;
        };
        extraOptions = [
          "--network=host"
          "--privileged"
        ];
      };
    };
  };
}
