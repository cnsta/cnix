{
  config,
  lib,
  ...
}: let
  unit = "prometheus";
  cfg = config.cnix.server.services.${unit};
  srv = config.cnix.server;
  exporters = config.services.prometheus.exporters;

  job = name: target: {
    job_name = name;
    static_configs = [{targets = [target];}];
  };
  local = port: "127.0.0.1:${toString port}";

  ports = {
    traefik = 9180;
    authelia = 9959;
  };
in {
  config = lib.mkIf cfg.enable {
    services.traefik.staticConfigOptions = lib.mkIf srv.infra.traefik.enable {
      entryPoints.metrics.address = local ports.traefik;
      metrics.prometheus = {
        entryPoint = "metrics";
        addEntryPointsLabels = true;
        addRoutersLabels = true;
        addServicesLabels = true;
      };
    };

    services.authelia.instances.main.settings.telemetry.metrics = lib.mkIf srv.services.authelia.enable {
      enabled = true;
      address = "tcp://${local ports.authelia}";
    };

    services.prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = cfg.port;
      retentionTime = "90d";
      extraFlags = ["--storage.tsdb.retention.size=20GB"];
      globalConfig = {
        scrape_interval = "15s";
        evaluation_interval = "15s";
      };

      scrapeConfigs =
        [
          (job "prometheus" (local cfg.port))
          (job "node" (local exporters.node.port))
          (job "systemd" (local exporters.systemd.port))
          (job "smartctl" (local exporters.smartctl.port))
        ]
        ++ lib.optional srv.infra.traefik.enable (job "traefik" (local ports.traefik))
        ++ lib.optional srv.infra.crowdsec.enable (job "crowdsec" (local (config.services.crowdsec.settings.config.prometheus.listen_port or 6060)))
        ++ lib.optional srv.infra.unbound.enable (job "unbound" (local exporters.unbound.port))
        ++ lib.optional config.services.postgresql.enable (job "postgres" (local exporters.postgres.port))
        ++ lib.optional srv.services.headscale.enable (job "headscale" config.services.headscale.settings.metrics_listen_addr)
        ++ lib.optional srv.services.authelia.enable (job "authelia" (local ports.authelia))
        ++ lib.optional srv.services.grafana.enable (job "grafana" (local srv.services.grafana.port))
        ++ lib.optional srv.services.hydra.enable (
          job "hydra" "[::1]:${toString config.services.hydra.queueRunner.rest.port}"
        )
        ++ lib.optional srv.services.speedtest-tracker.enable (
          job "speedtest" (local srv.services.speedtest-tracker.port)
          // {
            metrics_path = "/prometheus";
            scrape_interval = "60s";
          }
        );

      exporters = {
        node = {
          enable = true;
          listenAddress = "127.0.0.1";
          port = 9100;
          enabledCollectors = ["processes"];
        };

        systemd = {
          enable = true;
          listenAddress = "127.0.0.1";
          port = 9558;
        };

        smartctl = {
          enable = true;
          listenAddress = "127.0.0.1";
          port = 9633;
        };

        unbound = lib.mkIf srv.infra.unbound.enable {
          enable = true;
          listenAddress = "127.0.0.1";
          port = 9167;
          unbound = {
            host = "unix://${config.services.unbound.localControlSocketPath}";
            ca = null;
            certificate = null;
            key = null;
          };
        };

        postgres = lib.mkIf config.services.postgresql.enable {
          enable = true;
          listenAddress = "127.0.0.1";
          port = 9187;
          runAsLocalSuperUser = true;
        };
      };
    };
  };
}
