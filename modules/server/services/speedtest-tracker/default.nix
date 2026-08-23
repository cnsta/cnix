{
  config,
  lib,
  self,
  ...
}: let
  unit = "speedtest-tracker";
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf cfg.enable {
    age.secrets = {
      speedtestEnvironment.file = "${self}/secrets/speedtestEnvironment.age";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/speedtest-tracker 0750 1000 1000 -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "lscr.io/linuxserver/speedtest-tracker:latest";
        autoStart = true;
        ports = ["0.0.0.0:${toString cfg.port}:80"];
        volumes = [
          "/var/lib/speedtest-tracker:/config:rw"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          DB_CONNECTION = "sqlite";
        };
        environmentFiles = [config.age.secrets.speedtestEnvironment.path];
      };
    };
  };
}
