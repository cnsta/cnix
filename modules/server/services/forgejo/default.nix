{
  config,
  lib,
  self,
  pkgs,
  ...
}: let
  unit = "forgejo";
  cfg = config.server.services.${unit};
  domain = "${cfg.subdomain}.${config.server.infra.www.url}";
in {
  config = lib.mkIf cfg.enable {
    age.secrets.forgejoCloudflared.file = "${self}/secrets/forgejoCloudflared.age";

    server.infra = {
      fail2ban.jails.${unit} = {
        serviceName = "${unit}";
        failRegex = ''.*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>'';
      };
    };

    environment = {
      systemPackages = with pkgs; [
        forgejo-cli
      ];
    };

    services = {
      cloudflared = {
        enable = true;
        tunnels.${cfg.cloudflared.tunnelId} = {
          credentialsFile = cfg.cloudflared.credentialsFile;
          default = "http_status:404";
          ingress."${domain}".service = "http://localhost:${toString cfg.port}";
        };
      };

      forgejo = {
        enable = true;

        database.type = "postgres";

        lfs.enable = true;

        settings = {
          overall = {
            APP_NAME = "cnix forge";
          };
          cors = {
            ENABLED = true;
            # SCHEME = "https";
            ALLOW_DOMAIN = domain;
          };

          log.MODE = "console";

          mailer = {
            ENABLED = false;
            PROTOCOL = "sendmail";
            FROM = "noreply+adam@cnst.dev";
            SENDMAIL_PATH = "/run/wrappers/bin/sendmail";
          };

          picture.DISABLE_GRAVATAR = true;

          repository = {
            DEFAULT_BRANCH = "main";
            DEFAULT_REPO_UNITS = "repo.code,repo.issues,repo.pulls";
            DISABLE_DOWNLOAD_SOURCE_ARCHIVES = true;
          };

          indexer.REPO_INDEXER_ENABLED = true;

          oauth2_client = {
            ENABLE_AUTO_REGISTRATION = true;
            ACCOUNT_LINKING = "auto";
          };

          server = {
            DOMAIN = domain;
            LANDING_PAGE = "home";
            HTTP_PORT = cfg.port;
            ROOT_URL = "https://${domain}/";
          };

          ui = {
            DEFAULT_THEME = "forgejo-dark";
          };

          security.DISABLE_GIT_HOOKS = false;
          service.DISABLE_REGISTRATION = true;
          session.COOKIE_SECURE = true;
        };
      };
    };
  };
}
