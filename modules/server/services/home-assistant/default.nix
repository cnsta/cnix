{
  config,
  clib,
  lib,
  ...
}: let
  unit = "home-assistant";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    systemd.tmpfiles.rules = ["d ${cfg.configDir} 0775 ${srv.user} ${srv.group} - -"];
    virtualisation.oci-containers.containers = {
      ${unit} = {
        autoStart = true;
        image = "docker.io/homeassistant/home-assistant:stable";
        volumes = [
          "${cfg.configDir}:/config"
          "/run/dbus:/run/dbus:ro"
        ];
        environment = {
          inherit (clib.server.containerEnv config) TZ PUID PGID;
        };
        extraOptions = [
          "--network=host"
          "--privileged"
        ];
      };
    };
  };
}
