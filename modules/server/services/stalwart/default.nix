{
  config,
  lib,
  self,
  pkgs,
  ...
}:
with lib;
let
  unit = "stalwart";
  cfg = config.server.services.${unit};
  srv = config.server;
  domain = "mail.${srv.domain}";
in
{
  config = mkIf cfg.enable {
    age.secrets = {
      stalwartFallback = {
        owner = "stalwart-mail";
        group = "stalwart-mail";
        file = "${self}/secrets/stalwartFallback.age";
      };
      stalwartCloudflare = {
        file = "${self}/secrets/stalwartCloudflare.age";
        owner = "stalwart-mail";
        group = "stalwart-mail";
      };
    };

    networking.firewall.allowedTCPPorts = [
      25 # smtp
      465 # smtp tls
      993 # imap tls
      # 587 # smtp starttls
      4190 # manage sieve
      # 143 # imap starttls
    ];

    server.infra = {
      fail2ban = {
        jails = {
          ${unit} = {
            serviceName = unit;
            failRegex = ''^.*Username or password is incorrect.*IP:\s*<HOST>'';
          };
        };
      };
    };

    services.stalwart = {
      enable = true;
      package = pkgs.stalwart;
      settings =
        let
          ifthen = field: data: {
            "if" = field;
            "then" = data;
          };
          otherwise = value: { "else" = value; };
          is-smtp = ifthen "listener = 'smtp'";
          is-authenticated = data: {
            "if" = "!is_empty(authenticated_as)";
            "then" = data;
          };
        in
        {
          config.local-keys = [
            # defaults
            "store.*"
            "directory.*"
            "tracer.*"
            "server.*"
            "!server.blocked-ip.*"
            "!server.allowed-ip.*"
            "authentication.fallback-admin.*"
            "cluster.*"
            "storage.data"
            "storage.blob"
            "storage.lookup"
            "storage.fts"
            "storage.directory"
            # new
            "spam-filter.resource"
            "web-admin.resource"
            "web-admin.path"
            "config.local-keys.*"
            "lookup.default.hostname"
            "certificate.*"
            "auth.dkim.*"
            "signature.*"
            "imap.*"
            "session.*"
            "resolver.*"
          ];
          resolver = {
            type = "cloudflare";
            concurrency = 2;
            timeout = "10s";
            attempts = 3;
          };
          server = {
            hostname = domain;
            tls = {
              certificate = "default";
              ignore-client-order = true;
            };
            socket = {
              nodelay = true;
              reuse-addr = true;
            };
            listener = {
              smtp = {
                protocol = "smtp";
                bind = "[::]:25";
              };
              submissions = {
                protocol = "smtp";
                bind = "[::]:465";
                tls.implicit = true;
              };
              imaps = {
                protocol = "imap";
                bind = "[::]:993";
                tls.implicit = true;
              };
              http = {
                protocol = "http";
                bind = "127.0.0.1:8050";
                url = "https://${domain}";
                use-x-forwarded = true;
              };
              sieve = {
                protocol = "managesieve";
                bind = "[::]:4190";
                tls.implicit = true;
              };
            };
          };
          imap = {
            request.max-size = 52428800;
            auth = {
              max-failures = 3;
              allow-plain-text = false;
            };
            timeout = {
              authentication = "30m";
              anonymous = "1m";
              idle = "30m";
            };
            rate-limit = {
              requests = "20000/1m";
              concurrent = 32;
            };
          };

          auth.dkim.sign = [
            (ifthen "is_local_domain('*', sender_domain)" "['rsa-' + sender_domain, 'ed25519-' + sender_domain]")
            (otherwise false)
          ];

          session = {
            extensions = {
              pipelining = true;
              chunking = true;
              requiretls = true;
              no-soliciting = "";
              dsn = false;
              expn = [
                (is-authenticated true)
                (otherwise false)
              ];
              vrfy = [
                (is-authenticated true)
                (otherwise false)
              ];
              future-release = [
                (is-authenticated "30d")
                (otherwise false)
              ];
              deliver-by = [
                (is-authenticated "365d")
                (otherwise false)
              ];
              mt-priority = [
                (is-authenticated "mixer")
                (otherwise false)
              ];
            };

            mta-sts.mode = "testing";

            ehlo = {
              require = true;
              reject-non-fqdn = [
                (is-smtp true)
                (otherwise false)
              ];
            };

            rcpt = {
              catch-all = false;
              relay = [
                (is-authenticated true)
                (otherwise false)
              ];
              max-recipients = 25;
            };

            rate-limit = {
              inbound = "100/1h";
              concurrent = 5;
            };

            timeout = {
              command = "1m";
              data = "5m";
              idle = "5m";
            };
          };

          authentication.fallback-admin = {
            user = "admin";
            secret = "%{file:${config.age.secrets.stalwartFallback.path}}%";
          };

          acme."letsencrypt" = {
            directory = "https://acme-v02.api.letsencrypt.org/directory";
            challenge = "dns-01";
            contact = "acme3@${srv.domain}";
            domains = [ domain ];
            provider = "cloudflare";
            secret = "%{file:${config.age.secrets.stalwartCloudflare.path}}%";
          };
        };
    };
  };
}
