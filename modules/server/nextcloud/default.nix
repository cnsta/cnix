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
      default = "cloud.${srv.domainPublic}";
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
    cloudflared.credentialsFile = lib.mkOption {
      type = lib.types.str;
      example = lib.literalExpression ''
        pkgs.writeText "cloudflare-credentials.json" '''
        {"AccountTag":"secret"."TunnelSecret":"secret","TunnelID":"secret"}
        '''
      '';
    };
    cloudflared.tunnelId = lib.mkOption {
      type = lib.types.str;
      example = "00000000-0000-0000-0000-000000000000";
    };
  };
  config = lib.mkIf cfg.enable {
    services.cloudflared = {
      enable = true;
      tunnels.${cfg.cloudflared.tunnelId} = {
        credentialsFile = cfg.cloudflared.credentialsFile;
        default = "http_status:404";
        ingress."${cfg.url}".service = "http://127.0.0.1:8083";
      };
    };

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
        "opcache.jit" = "tracing";
        "opcache.jit_buffer_size" = "100M";
        "opcache.interned_strings_buffer" = "16";
        "opcache.max_accelerated_files" = "10000";
        "opcache.memory_consumption" = "1280";
      };
      maxUploadSize = "50G";
      settings = {
        maintenance_window_start = "1";
        trusted_proxies = ["127.0.0.1"];
        trusted_domains = ["cloud.${srv.domainPublic}"];
        overwriteprotocol = "https";
        overwritehost = "cloud.${srv.domainPublic}";
        overwrite.cli.url = "https://cloud.${srv.domainPublic}";
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
        adminuser = "cnst";
        adminpassFile = cfg.adminpassFile;
      };
    };
    services = {
      nginx = {
        virtualHosts.nextcloud = {
          useACMEHost = srv.domainPublic;
          listen = [
            {
              addr = "127.0.0.1";
              port = 8083;
            }
          ];
          extraConfig = ''
            add_header Referrer-Policy                      "no-referrer"   always;
            add_header X-Content-Type-Options               "nosniff"       always;
            add_header X-Download-Options                   "noopen"        always;
            add_header X-Frame-Options                      "SAMEORIGIN"    always;
            add_header X-Permitted-Cross-Domain-Policies    "none"          always;
            add_header X-Robots-Tag                         "none"          always;
            add_header X-XSS-Protection                     "1; mode=block" always;
            add_header Strict-Transport-Security "max-age=15552000; includeSubDomains;";

            access_log /var/log/nginx/nextcloud.access.log;
            error_log /var/log/nginx/nextcloud.error.log;
          '';
        };
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
