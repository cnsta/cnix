{
  config,
  lib,
  ...
}:
let
  cfg = config.server.services.grafana;
in
{
  config = lib.mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9090;
      globalConfig = {
        scrape_interval = "15s";
        evaluation_interval = "15s";
      };
      scrapeConfigs = [
        {
          job_name = "postfix";
          static_configs = [
            { targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.postfix.port}" ]; }
          ];
        }
        {
          job_name = "rspamd";
          metrics_path = "/metrics";
          static_configs = [
            { targets = [ "127.0.0.1:11334" ]; }
          ];
        }
        {
          job_name = "node";
          static_configs = [
            { targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ]; }
          ];
        }
        {
          job_name = "systemd";
          static_configs = [
            { targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.systemd.port}" ]; }
          ];
        }
      ];
      exporters = {
        postfix = {
          enable = true;
          listenAddress = "127.0.0.1";
          port = 9154;
          systemd.enable = true;
          showqPath = "/var/lib/postfix/queue/public/showq";
        };

        node = {
          enable = true;
          listenAddress = "127.0.0.1";
          port = 9100;
          enabledCollectors = [
            "cpu"
            "diskstats"
            "filesystem"
            "loadavg"
            "meminfo"
            "netdev"
            "stat"
            "time"
            "systemd"
          ];
        };
        systemd = {
          enable = true;
          listenAddress = "127.0.0.1";
          port = 9558;
        };
      };
    };
  };
}
