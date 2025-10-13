{
  config,
  pkgs,
  lib,
  self,
  ...
}: let
  unit = "nextcloud";
  cfg = config.server.services.${unit};
  srv = config.server;
in {
  config = lib.mkIf cfg.enable {
    age.secrets = {
      nextcloudAdminPass.file = "${self}/secrets/nextcloudAdminPass.age";
      nextcloudCloudflared.file = "${self}/secrets/nextcloudCloudflared.age";
    };

    server.infra.fail2ban.jails.nextcloud = {
      serviceName = "${unit}";
      _groupsre = ''(?:(?:,?\s*"\w+":(?:"[^"]+"|\w+))*)'';
      failRegex = ''
        ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Login failed:
                    ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Two-factor challenge failed:
                    ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Trusted domain error.
      '';
      datePattern = '',?\s*"time"\s*:\s*"%%Y-%%m-%%d[T ]%%H:%%M:%%S(%%z)?"'';
    };

    services = {
      ${unit} = {
        enable = true;
        package = pkgs.nextcloud32;
        hostName = "nextcloud";
        configureRedis = true;
        caching = {
          redis = true;
        };
        phpOptions = {
          "opcache.interned_strings_buffer" = "32";
        };
        maxUploadSize = "50G";
        settings = {
          maintenance_window_start = "1";
          trusted_proxies = [
            "127.0.0.1"
            "::1"
          ];
          trusted_domains = ["cloud.${srv.domain}"];
          overwriteprotocol = "https";
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
          adminuser = "cnst";
          adminpassFile = config.age.secrets.nextcloudAdminPass.path;
        };
      };

      nginx = {
        defaultListen = [
          {
            addr = "127.0.0.1";
            port = 8182;
          }
          {
            addr = "127.0.0.1";
            port = 8482;
          }
        ];
        virtualHosts.nextcloud = {
          forceSSL = false;
        };
      };
    };

    server.infra.postgresql.databases = [
      {
        database = "nextcloud";
      }
    ];
    systemd.services."nextcloud-setup" = {
      requires = ["postgresql.service"];
      after = ["postgresql.service"];
    };
  };
}
