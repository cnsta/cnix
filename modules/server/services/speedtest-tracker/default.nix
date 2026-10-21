{
  config,
  lib,
  self,
  ...
}: let
  unit = "speedtest-tracker";
  srv = config.cnix.server;
  cfg = srv.services.${unit};
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
        ports = ["127.0.0.1:${toString cfg.port}:80"];
        volumes = [
          "/var/lib/speedtest-tracker:/config:rw"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          DB_CONNECTION = "sqlite";
          SPEEDTEST_SCHEDULE = "17 */4 * * *";
          PRUNE_RESULTS_OLDER_THAN = "365";
          DISPLAY_TIMEZONE = srv.timeZone;
          DATETIME_FORMAT = "j M Y, H:i";
          CHART_DATETIME_FORMAT = "j/n H:i";
        };
        environmentFiles = [config.age.secrets.speedtestEnvironment.path];
      };
    };
  };
}
