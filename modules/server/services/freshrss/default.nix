{
  config,
  lib,
  clib,
  ...
}:
let
  unit = "freshrss";
  cfg = config.server.services.${unit};
  authelia = config.server.services.authelia;
  domain = clib.server.mkFullDomain config cfg;
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
      defaultUser = "admin";
      language = "en";
      database = {
        type = "pgsql";
        host = "/run/postgresql";
        port = null;
        user = "freshrss";
        name = "freshrss";
        passFile = null;
      };
    };

    services.nginx.virtualHosts.${domain} = {
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
  };
}
