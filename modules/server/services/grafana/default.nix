{
  config,
  lib,
  clib,
  self,
  ...
}: let
  unit = "grafana";
  cfg = config.cnix.server.services.${unit};
  srv = config.cnix.server;
  domain = clib.server.mkFullDomain config cfg;
  autheliaUrl = "https://login.${clib.server.mkHostDomain config cfg}";
  prometheus = srv.services.prometheus;
  file = path: "$__file{${path}}";
in {
  imports = [
    ./dashboards.nix
    ./alerts.nix
  ];

  config = lib.mkIf cfg.enable {
    age.secrets = {
      grafanaSecretKey = {
        owner = unit;
        group = unit;
        file = "${self}/secrets/grafanaSecretKey.age";
      };
      grafanaOidcSecret = {
        owner = unit;
        group = unit;
        file = "${self}/secrets/grafanaOidcSecret.age";
      };
      smtp = lib.mkIf (srv.smtp != null) {
        owner = unit;
        group = unit;
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
        security.secret_key = file config.age.secrets.grafanaSecretKey.path;
        analytics.reporting_enabled = false;

        "auth.generic_oauth" = {
          enabled = true;
          name = "Authelia";
          icon = "signin";
          client_id = unit;
          client_secret = file config.age.secrets.grafanaOidcSecret.path;
          auth_style = "InHeader";
          scopes = "openid profile email groups";
          auth_url = "${autheliaUrl}/api/oidc/authorization";
          token_url = "${autheliaUrl}/api/oidc/token";
          api_url = "${autheliaUrl}/api/oidc/userinfo";
          use_pkce = true;
          auto_login = true;
          allow_sign_up = true;
          login_attribute_path = "preferred_username";
          name_attribute_path = "name";
          email_attribute_path = "email";
          groups_attribute_path = "groups";
          role_attribute_path = "contains(groups[*], 'admins') && 'Admin' || 'Viewer'";
          role_attribute_strict = true;
        };

        smtp = lib.mkIf (srv.smtp != null) {
          enabled = true;
          inherit (srv.smtp) host user;
          password = file srv.smtp.passwordFile;
          from_address = srv.smtp.from;
          from_name = "cnix alerts";
          startTLS_policy = "MandatoryStartTLS";
        };
      };

      provision = {
        enable = true;
        datasources.settings.deleteDatasources = lib.optional prometheus.enable {
          name = "Prometheus";
          orgId = 1;
        };
        datasources.settings.datasources = lib.optional prometheus.enable {
          name = "Prometheus";
          type = "prometheus";
          # dashboards and alert rules reference this uid.
          uid = "prometheus";
          url = "http://127.0.0.1:${toString prometheus.port}";
          isDefault = true;
          editable = false;
        };
      };
    };
  };
}
