{
  config,
  pkgs,
  lib,
  ...
}:
let
  unit = "nextcloud";
  cfg = config.server.${unit};
  srv = config.server;
in
{
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    adminUser = lib.mkOption {
      type = lib.types.str;
      default = "cnst";
    };
    adminPass = lib.mkOption {
      type = lib.types.path;
    };
    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/${unit}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "cloud.${srv.domain}";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Nextcloud";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "A safe home for all your data";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "nextcloud.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
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
    server = {
      postgresql.databases = [
        {
          database = "nextcloud";
        }
      ];
      fail2ban = lib.mkIf config.server.fail2ban.enable {
        jails = {
          nextcloud = {
            serviceName = "phpfm-nextcloud";
            failRegex = "^.*Login failed:.*(Remote IP: <HOST>).*$";
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
          ingress."${cfg.url}".service = "http://127.0.0.1:8083";
        };
      };

      ${unit} = {
        enable = true;
        package = pkgs.nextcloud31;
        hostName = "nextcloud";
        configureRedis = true;
        caching = {
          redis = true;
        };
        maxUploadSize = "50G";
        settings = {
          trusted_proxies = [ "127.0.0.1" ];
          overwriteprotocol = "https";
          overwritehost = "cloud.${srv.domain}";
          overwrite.cli.url = "https://cloud.${srv.domain}";
          mail_smtpmode = "sendmail";
          mail_sendmailmode = "pipe";
          user_oidc = {
            allow_multiple_user_backends = 0;
          };
          forwarded_for_headers = [
            "HTTP_CF_CONNECTING_IP"
          ];
          enabledPreviewProviders = [
            "OC\\Preview\\BMP"
            "OC\\Preview\\GIF"
            "OC\\Preview\\JPEG"
            "OC\\Preview\\Krita"
            "OC\\Preview\\MarkDown"
            "OC\\Preview\\MP3"
            "OC\\Preview\\OpenDocument"
            "OC\\Preview\\PNG"
            "OC\\Preview\\TXT"
            "OC\\Preview\\XBitmap"
            "OC\\Preview\\HEIC"
          ];
        };
        config = {
          dbtype = "pgsql";
          dbuser = "nextcloud";
          dbhost = "/run/postgresql";
          dbname = "nextcloud";
          adminuser = cfg.adminUser;
          adminpassFile = cfg.adminPass;
        };
      };
    };
  };
}
