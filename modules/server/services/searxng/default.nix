{
  config,
  lib,
  self,
  ...
}:
let
  unit = "searxng";
  srv = config.server;
  cfg = config.server.services.${unit};
in
{
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      searxngEnvironment = {
        file = "${self}/secrets/searxngEnvironment.age";
        owner = "977";
        group = "977";
        mode = "0444";
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/searxng 0750 977 977 -"
      "d /var/cache/searxng 0750 977 977 -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "docker.io/searxng/searxng:latest";
        autoStart = true;
        dependsOn = [
          "gluetun-searxng"
          "valkey-searxng"
        ];
        extraOptions = [ "--network=container:gluetun-searxng" ];
        environmentFiles = [ config.age.secrets.searxngEnvironment.path ];
        volumes = [
          "/var/lib/searxng:/etc/searxng"
          "/var/cache/searxng:/var/cache/searxng"
        ];
      };

      valkey-searxng = {
        image = "docker.io/valkey/valkey:9-alpine";
        autoStart = true;
        dependsOn = [ "gluetun-searxng" ];
        extraOptions = [ "--network=container:gluetun-searxng" ];
        cmd = [
          "valkey-server"
          "--save"
          "30"
          "1"
          "--loglevel"
          "warning"
        ];
        volumes = [ "/var/lib/valkey-searxng:/data" ];
      };
    };
  };
}
