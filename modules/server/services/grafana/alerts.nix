{
  config,
  lib,
  ...
}: let
  srv = config.cnix.server;
  cfg = srv.services.grafana;

  rule = {
    uid,
    title,
    expr,
    summary,
    above ? 0,
    for ? "5m",
  }: {
    inherit uid title for;
    condition = "B";
    data = [
      {
        refId = "A";
        datasourceUid = "prometheus";
        relativeTimeRange = {
          from = 600;
          to = 0;
        };
        model = {
          refId = "A";
          inherit expr;
          instant = true;
        };
      }
      {
        refId = "B";
        datasourceUid = "__expr__";
        model = {
          refId = "B";
          type = "threshold";
          expression = "A";
          conditions = [
            {
              evaluator = {
                type = "gt";
                params = [above];
              };
            }
          ];
        };
      }
    ];
    noDataState = "OK";
    execErrState = "Error";
    annotations.summary = summary;
  };

  rules = [
    (rule {
      uid = "target-down";
      title = "Scrape target down";
      expr = "1 - up";
      summary = "{{ $labels.job }} ({{ $labels.instance }}) is not answering /metrics.";
    })
    (rule {
      uid = "unit-failed";
      title = "systemd unit failed";
      expr = ''systemd_unit_state{state="failed"}'';
      summary = "{{ $labels.name }} is in the failed state.";
    })
    (rule {
      uid = "zpool-degraded";
      title = "zpool not online";
      expr = ''node_zfs_zpool_state{state!="online"}'';
      summary = "zpool {{ $labels.zpool }} is {{ $labels.state }}.";
      for = "1m";
    })
    (rule {
      uid = "smart-failing";
      title = "SMART health check failing";
      expr = "1 - smartctl_device_smart_status";
      summary = "{{ $labels.device }} reports a failing SMART status.";
      for = "1m";
    })
    (rule {
      uid = "disk-full";
      title = "Filesystem almost full";
      expr = ''1 - node_filesystem_avail_bytes{fstype=~"ext4|vfat|zfs"} / node_filesystem_size_bytes{fstype=~"ext4|vfat|zfs"}'';
      above = 0.85;
      summary = "{{ $labels.mountpoint }} is {{ humanizePercentage $values.A.Value }} full.";
      for = "15m";
    })
    (rule {
      uid = "memory-pressure";
      title = "Memory pressure";
      # Share of wall time in which some task stalled on memory (PSI).
      expr = "rate(node_pressure_memory_waiting_seconds_total[5m])";
      above = 0.2;
      summary = "Tasks stalled on memory {{ humanizePercentage $values.A.Value }} of the time.";
      for = "15m";
    })
    (rule {
      uid = "cert-expiry";
      title = "TLS certificate expiring";
      expr = "(time() - traefik_tls_certs_not_after) / 86400 + 14";
      summary = "{{ $labels.cn }} expires within 14 days; ACME renewal is failing.";
      for = "1h";
    })
    (rule {
      uid = "postgres-down";
      title = "PostgreSQL down";
      expr = "1 - pg_up";
      summary = "postgres_exporter can't reach PostgreSQL.";
      for = "2m";
    })
  ];
in {
  config = lib.mkIf (cfg.enable && srv.services.prometheus.enable) {
    services.grafana.provision.alerting = {
      rules.settings = {
        apiVersion = 1;
        groups = [
          {
            orgId = 1;
            name = "sobotka";
            folder = "sobotka";
            interval = "1m";
            inherit rules;
          }
        ];
      };

      contactPoints.settings = lib.mkIf (srv.smtp != null) {
        apiVersion = 1;
        contactPoints = [
          {
            orgId = 1;
            name = "email";
            receivers = [
              {
                uid = "email";
                type = "email";
                settings.addresses = srv.email;
              }
            ];
          }
        ];
      };

      policies.settings = lib.mkIf (srv.smtp != null) {
        apiVersion = 1;
        policies = [
          {
            orgId = 1;
            receiver = "email";
            group_by = ["alertname"];
            repeat_interval = "12h";
          }
        ];
      };
    };
  };
}
