# "inspired" by @jtojnar <3
{
  config,
  lib,
  self,
  ...
}: let
  unit = "gitea";
  cfg = config.server.services.${unit};
in {
  config = lib.mkIf cfg.enable {
    age.secrets = {
      giteaCloudflared.file = "${self}/secrets/giteaCloudflared.age";
    };

    server.infra = {
      fail2ban = {
        jails = {
          gitea = {
            serviceName = "gitea";
            failRegex = ''.*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>'';
          };
        };
      };
    };

    services = {
      cloudflared = {
        enable = true;
        tunnels.${cfg.cloudflared.tunnelId} = {
          credentialsFile = cfg.cloudflared.credentialsFile;
          default = "http_status:404";
          ingress."${cfg.url}".service = "http://localhost:${toString cfg.port}";
        };
      };

      ${unit} = {
        enable = true;
        appName = "cnix code forge";

        database = {
          type = "postgres";
          socket = "/run/postgresql";
          name = "gitea";
          user = "gitea";
          createDatabase = false;
        };

        lfs = {
          enable = true;
        };

        settings = {
          cors = {
            ENABLED = true;
            SCHEME = "https";
            ALLOW_DOMAIN = cfg.url;
          };
          log = {
            MODE = "console";
          };
          mailer = {
            ENABLED = false;
            MAILER_TYPE = "sendmail";
            FROM = "noreply+adam@cnst.dev";
            SENDMAIL_PATH = "/run/wrappers/bin/sendmail";
          };
          picture = {
            DISABLE_GRAVATAR = true;
          };
          repository = {
            DEFAULT_BRANCH = "main";
            DEFAULT_REPO_UNITS = "repo.code,repo.issues,repo.pulls";
            DISABLE_DOWNLOAD_SOURCE_ARCHIVES = true;
          };
          indexer = {
            REPO_INDEXER_ENABLED = true;
          };
          oauth2_client = {
            ENABLE_AUTO_REGISTRATION = true;
            ACCOUNT_LINKING = "auto";
          };
          server = {
            DOMAIN = cfg.url;
            LANDING_PAGE = "explore";
            HTTP_PORT = cfg.port;
            ROOT_URL = "https://${cfg.url}/";
          };
          security = {
            DISABLE_GIT_HOOKS = false;
          };
          service = {
            DISABLE_REGISTRATION = true;
          };
          session = {
            COOKIE_SECURE = true;
          };
        };
      };
    };

    server.infra.postgresql.databases = [
      {
        database = "gitea";
      }
    ];
  };
}
