{
  config,
  lib,
  clib,
  pkgs,
  ...
}:
let
  unit = "freshrss";
  cfg = config.server.services.${unit};
  authelia = config.server.services.authelia;
  domain = clib.server.mkFullDomain config cfg;
  hostDomain = clib.server.mkHostDomain config cfg;
  buildExt = pkgs.freshrss-extensions.buildFreshRssExtension;
in
{
  config = lib.mkIf cfg.enable {
    server.infra = {
      postgresql.databases = [
        { database = unit; }
      ];
    };

    services.freshrss = {
      enable = true;
      authType = "http_auth";
      api.enable = true;
      virtualHost = domain;
      baseUrl = "https://${domain}";
      defaultUser = "cnst";
      language = "en";
      database = {
        type = "pgsql";
        host = "/run/postgresql";
        port = null;
        user = "freshrss";
        name = "freshrss";
        passFile = null;
      };
      extensions =
        with pkgs.freshrss-extensions;
        [
          youtube
        ]
        ++ [
          (buildExt {
            FreshRssExtUniqueId = "FlareSolverr";
            pname = "flare-solverr";
            version = "0.4.3";
            src = pkgs.fetchFromGitHub {
              owner = "ravenscroftj";
              repo = "freshrss-flaresolverr-extension";
              rev = "f01c02dff8cf26dc6e5a52fe3443aa321a3a620a";
              hash = "sha256-GiC8mYBN/Y22/tB++HLMHUKJViMV9h2hNrI5upXodNM=";
            };
          })
        ];
    };

    services.nginx.virtualHosts = {
      ${domain} = {
        listen = lib.mkForce [
          {
            addr = "127.0.0.1";
            port = cfg.port;
            ssl = false;
          }
        ];

        extraConfig = ''
          auth_request_set $redirection_url $upstream_http_location;
          error_page 401 =302 $redirection_url;
        '';

        locations."~ ^.+?\\.php(/.*)?$".extraConfig = ''
          auth_request /authelia;
          auth_request_set $user $upstream_http_remote_user;
          fastcgi_param REMOTE_USER $user;
        '';

        locations."/authelia" = {
          proxyPass = "http://127.0.0.1:${toString authelia.port}/api/authz/auth-request";
          extraConfig = ''
            internal;
            proxy_pass_request_body off;
            proxy_set_header Content-Length "";
            proxy_set_header X-Original-URL https://$http_host$request_uri;
            proxy_set_header X-Original-Method $request_method;
            proxy_set_header X-Forwarded-Method $request_method;
            proxy_set_header X-Forwarded-Proto https;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Forwarded-Uri $request_uri;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_connect_timeout 5s;
            proxy_send_timeout 5s;
            proxy_read_timeout 5s;
          '';
        };
      };

      "rss-api.${hostDomain}" = {
        root = "${pkgs.freshrss}/p";

        locations."~ ^/(api/)?(accounts|reader)" = {
          extraConfig = ''
            rewrite ^/api/(.*)$ /api/greader.php/$1 last;
            rewrite ^/(.*)$ /api/greader.php/$1 last;
          '';
        };

        locations."~ ^/api/.+\\.php(/.*)?$" = {
          extraConfig = ''
            # No Authelia - FreshRSS handles API authentication

            # FastCGI configuration for PHP
            fastcgi_pass unix:${config.services.phpfpm.pools.freshrss.socket};
            fastcgi_index index.php;
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            set $path_info $fastcgi_path_info;
            fastcgi_param PATH_INFO $path_info;
            fastcgi_param SCRIPT_FILENAME ${pkgs.freshrss}/p$fastcgi_script_name;

            # Security: explicitly clear REMOTE_USER to prevent auth bypass
            fastcgi_param REMOTE_USER "";

            include ${pkgs.nginx}/conf/fastcgi.conf;
          '';
        };

        locations."/" = {
          extraConfig = ''
            return 404;
          '';
        };
      };
    };
  };
}
