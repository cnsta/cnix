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

    services.${unit} = {
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
    users.groups.nextcloud.members = [
      config.services.caddy.user
    ];
    services = {
      nginx.enable = false;

      phpfpm.pools.nextcloud.settings = {
        "listen.owner" = config.services.caddy.user;
        "listen.group" = config.services.caddy.group;
      };

      caddy.virtualHosts.${cfg.url} = let
        webroot = config.services.nginx.virtualHosts.nextcloud.root;
      in {
        useACMEHost = srv.domain;
        extraConfig = ''
            encode zstd gzip

            root * ${webroot}

            redir /.well-known/carddav /remote.php/dav 301
            redir /.well-known/caldav /remote.php/dav 301
            redir /.well-known/* /index.php{uri} 301
            redir /remote/* /remote.php{uri} 301

            header {
                Strict-Transport-Security max-age=31536000
                Permissions-Policy interest-cohort=()
                X-Content-Type-Options nosniff
                X-Frame-Options SAMEORIGIN
                Referrer-Policy no-referrer
                X-XSS-Protection "1; mode=block"
                X-Permitted-Cross-Domain-Policies none
                X-Robots-Tag "noindex, nofollow"
                -X-Powered-By
            }

            php_fastcgi unix/${config.services.phpfpm.pools.nextcloud.socket} {
                root ${webroot}
                env front_controller_active true
                env modHeadersAvailable true
            }

            @forbidden {
                path /build/* /tests/* /config/* /lib/* /3rdparty/* /templates/* /data/*
                path /.* /autotest* /occ* /issue* /indie* /db_* /console*
                not path /.well-known/*
            }
            error @forbidden 404

            @immutable {
                path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
                query v=*
            }
            header @immutable Cache-Control "max-age=15778463, immutable"

          @static {
              path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
              not query v=*
          }
          header @static Cache-Control "max-age=15778463"

          @woff2 path *.woff2
          header @woff2 Cache-Control "max-age=604800"

          file_server
        '';
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
