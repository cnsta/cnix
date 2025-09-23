{
  config,
  pkgs,
  lib,
  ...
}: let
  unit = "nextcloud";
  cfg = config.server.${unit};
  srv = config.server;
in {
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    adminpassFile = lib.mkOption {
      type = lib.types.path;
    };
    adminuser = lib.mkOption {
      type = lib.types.str;
      default = "cnst";
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
  };
  config = lib.mkIf cfg.enable {
    server.fail2ban = lib.mkIf config.server.fail2ban.enable {
      jails = {
        nextcloud = {
          serviceName = "phpfpm-nextcloud";
          failRegex = "^.*Login failed:.*(Remote IP: <HOST>).*$";
        };
      };
    };

    services = {
      ${unit} = {
        enable = true;
        package = pkgs.nextcloud31;
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
          adminpassFile = cfg.adminpassFile;
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

      traefik.dynamicConfigOptions.http = {
        routers.nextcloud = {
          entryPoints = ["websecure"];
          rule = "Host(`${cfg.url}`)";
          service = "nextcloud";
          tls.certResolver = "letsencrypt";
        };
        services.nextcloud.loadBalancer.servers = [
          {url = "http://127.0.0.1:8182";}
        ];
      };
    };

    server.postgresql.databases = [
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
