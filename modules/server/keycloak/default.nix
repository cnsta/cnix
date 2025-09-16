{
  config,
  lib,
  pkgs,
  ...
}: let
  unit = "keycloak";
  cfg = config.server.${unit};
  srv = config.server;
in {
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "login.${srv.domain}";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Keycloak";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Open Source Identity and Access Management";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "keycloak.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
    dbPasswordFile = lib.mkOption {
      type = lib.types.path;
    };
    cloudflared = {
      credentialsFile = lib.mkOption {
        type = lib.types.str;
        example = lib.literalExpression ''
          pkgs.writeText "cloudflare-credentials.json" '''
          {"AccountTag":"secret"."TunnelSecret":"secret","TunnelID":"secret"}
          '''
        '';
      };
      tunnelId = lib.mkOption {
        type = lib.types.str;
        example = "00000000-0000-0000-0000-000000000000";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    server.postgresql.databases = [
      {
        database = "keycloak";
      }
    ];
    services.cloudflared = {
      enable = true;
      tunnels.${cfg.cloudflared.tunnelId} = {
        credentialsFile = cfg.cloudflared.credentialsFile;
        default = "http_status:404";
        ingress."${cfg.url}".service = "http://127.0.0.1:${
          toString config.services.${unit}.settings.http-port
        }";
      };
    };

    environment.systemPackages = [
      pkgs.keycloak
    ];

    services.${unit} = {
      enable = true;
      initialAdminPassword = "pwpwpw";
      database = {
        type = "postgresql";
        host = "127.0.0.1";
        port = 5432;
        name = "keycloak";
        username = "keycloak";
        passwordFile = cfg.dbPasswordFile;
        useSSL = false;
      };
      settings = {
        spi-theme-static-max-age = "-1";
        spi-theme-cache-themes = false;
        spi-theme-cache-templates = false;
        http-port = 8821;
        hostname = cfg.url;
        hostname-strict = false;
        hostname-strict-https = false;
        proxy-headers = "xforwarded";
        http-enabled = true;
      };
    };
  };
}
