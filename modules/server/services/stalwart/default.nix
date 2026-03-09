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
        file = "${self}/secrets/stalwartFallback.age";
        owner = "stalwart-mail";
        group = "stalwart-mail";
      };

      stalwartCloudflare = {
        file = "${self}/secrets/stalwartCloudflare.age";
        owner = "stalwart-mail";
        group = "stalwart-mail";
      };

      stalwartDkimEd = {
        file = "${self}/secrets/stalwartDkimEd.age";
        owner = "stalwart-mail";
        group = "stalwart-mail";
      };

      stalwartDkimRsa = {
        file = "${self}/secrets/stalwartDkimRsa.age";
        owner = "stalwart-mail";
        group = "stalwart-mail";
      };
    };

    networking.firewall.allowedTCPPorts = [
      25 # smtp
      465 # smtp tls
      993 # imap tls
      4190 # manage sieve
      # 587 # smtp starttls
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
          is-submissions = ifthen "listener = 'submissions'";
          is-authenticated = ifthen "!is_empty(authenticated_as)";
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
            "queue.*"
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
            (is-submissions "['rsa-' + sender_domain, 'ed25519-' + sender_domain]")
            (otherwise false)
          ];

          signature = {
            "ed25519-${srv.domain}" = {
              private-key = "%{file:${config.age.secrets.stalwartDkimEd.path}}%";
              selector = "ed_default";
              domain = srv.domain;
              headers = [
                "From"
                "To"
                "Date"
                "Subject"
                "Message-ID"
              ];
              algorithm = "ed25519-sha256";
              canonicalization = "relaxed/relaxed";
              set-body-length = false;
              report = true;
            };

            "rsa-${srv.domain}" = {
              private-key = "%{file:${config.age.secrets.stalwartDkimRsa.path}}%";
              selector = "rsa_default";
              domain = srv.domain;
              headers = [
                "From"
                "To"
                "Date"
                "Subject"
                "Message-ID"
              ];
              algorithm = "rsa-sha256";
              canonicalization = "relaxed/relaxed";
              set-body-length = false;
              report = true;
            };
          };

          queue = {
            virtual.outbound.threads-per-node = 8;

            route = {
              "mx" = {
                type = "mx";
                ip-lookup = "ipv4_then_ipv6";
                limits = {
                  mx = 5;
                  multihomed = 2;
                };
              };
              "local" = {
                type = "local";
              };
            };

            strategy = {
              queue = "outbound";
              route = [
                (ifthen "is_local_domain('*', rcpt_domain)" "'local'")
                (otherwise "'mx'")
              ];
            };
          };

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

            mta-sts.mode = "testing"; # change to enforce

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
