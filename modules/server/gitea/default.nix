# "inspired" by @jtojnar <3
{
  config,
  lib,
  self,
  ...
}: let
  unit = "gitea";
  srv = config.server;
  cfg = config.server.${unit};
in {
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "git.${srv.domain}";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 5003;
      description = "The port to host Gitea on.";
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
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Gitea";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Git with a cup of tea";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "gitea.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };
  config = lib.mkIf cfg.enable {
    age.secrets = {
      giteaCloudflared.file = "${self}/secrets/giteaCloudflared.age";
    };

    server = {
      fail2ban = lib.mkIf config.server.fail2ban.enable {
        jails = {
          gitea = {
            serviceName = "gitea";
            failRegex = "^.*Username or password is incorrect. Try again. IP: <HOST>. Username: <F-USER>.*</F-USER>.$";
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

    services.traefik = {
      dynamicConfigOptions = {
        http = {
          services.gitea.loadBalancer.servers = [{url = "http://127.0.0.1:5003";}];
          routers = {
            gitea = {
              entryPoints = ["websecure"];
              rule = "Host(`${cfg.url}`)";
              service = "gitea";
              tls.certResolver = "letsencrypt";
              # middlewares = ["authentik"];
            };
          };
        };
      };
    };

    server.postgresql.databases = [
      {
        database = "gitea";
      }
    ];
  };
}
