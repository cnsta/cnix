{
  config,
  lib,
  clib,
  self,
  ...
}:
let
  unit = "grafana";
  cfg = config.server.services.${unit};
  domain = clib.server.mkFullDomain config cfg;
in
{
  config = lib.mkIf cfg.enable {
    age.secrets = {
      grafanaSecretKey = {
        owner = unit;
        group = unit;
        file = "${self}/secrets/grafanaSecretKey.age";
      };
    };
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = cfg.port;
          domain = domain;
          root_url = "https://${domain}";
        };
        security.secret_key = config.age.secrets.grafanaSecretKey.path;
        analytics.reporting_enabled = false;
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://127.0.0.1:${toString config.services.prometheus.port}";
            isDefault = true;
            editable = false;
          }
        ];
      };
    };
  };
}
