{
  config,
  lib,
  pkgs,
  clib,
  ...
}: let
  unit = "forgejo";
  cfg = config.cnix.server.services.${unit};
  srv = config.cnix.server;
  domain = clib.server.mkFullDomain config cfg;
  appName = "cnix forge";
  relay = lib.splitString ":" srv.smtp.host;
in {
  config = lib.mkIf cfg.enable {
    cnix.server.infra = {
      fail2ban.jails.${unit} = {
        serviceName = "${unit}";
        failRegex = ".*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>";
      };
      postgresql.databases = [
        {
          database = unit;
          extraUsers = ["cnst"];
        }
      ];
    };

    environment = {
      systemPackages = with pkgs; [
        forgejo-cli
      ];
    };
    services = {
      forgejo = {
        enable = true;
        database.type = "postgres";
        lfs.enable = true;
        package = pkgs.forgejo;

        secrets.mailer.PASSWD = lib.mkIf (srv.smtp != null) srv.smtp.passwordFile;

        settings = {
          overall = {
            APP_NAME = appName;
          };
          cors = {
            ENABLED = true;
            # SCHEME = "https";
            ALLOW_DOMAIN = domain;
          };

          log.MODE = "console";

          mailer = lib.mkIf (srv.smtp != null) {
            ENABLED = true;
            PROTOCOL = "smtp+starttls";
            SMTP_ADDR = builtins.elemAt relay 0;
            SMTP_PORT = lib.toInt (builtins.elemAt relay 1);
            USER = srv.smtp.user;
            FROM = "\"${appName}\" <${srv.smtp.from}>";
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
            HTTP_ADDR = "127.0.0.1";
            DOMAIN = domain;
            LANDING_PAGE = "explore";
            HTTP_PORT = cfg.port;
            ROOT_URL = "https://${domain}/";
          };

          ui = {
            DEFAULT_THEME = "forgejo-dark";
          };

          security.DISABLE_GIT_HOOKS = false;
          service = {
            DISABLE_REGISTRATION = true;
            ENABLE_NOTIFY_MAIL = srv.smtp != null;
          };
          session.COOKIE_SECURE = true;
        };
      };
    };
  };
}
