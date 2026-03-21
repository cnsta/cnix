{
  config,
  lib,
  self,
  pkgs,
  inputs,
  ...
}:

# ─────────────────────────────────────────────────────────────────────────────
#  server.infra.mail — host-level wrapper around the cnixpost NixOS module.
#
#  cnixpost is consumed as a flake input in the host flake:
#    cnixpost.url = "github:cnsta/cnixpost";
#    cnixpost.inputs.nixpkgs.follows = "nixpkgs";
#  and imported here so the cnixpost.* options are available to wire up below.
#
#  TLS certificate source:
#    Traefik manages a wildcard cert for *.domain via its letsencrypt resolver
#    and stores it in /var/lib/traefik/cert.json (base64-encoded PEM).
#    A systemd path unit watches cert.json and re-extracts the PEM files to
#    /run/mail-certs/ on every renewal, then reloads postfix and dovecot.
#
#  PROXY protocol:
#    Traefik fronts all six mail ports as TCP proxies.  Without PROXY protocol,
#    Postfix and Dovecot see every client as 127.0.0.1, defeating postscreen
#    DNSBL, per-IP rate limiting, fail2ban, and Rspamd IP reputation.
#    Every Traefik TCP service sends PROXY protocol v2 headers;
#    Postfix and Dovecot consume them.
#
#  Bind interfaces:
#    Postfix (inet_interfaces = 127.0.0.1) and Dovecot (listen = 127.0.0.1)
#    bind on loopback only.  Traefik owns the public-facing ports and forwards
#    to localhost.  Without this, Postfix/Dovecot and Traefik both try to bind
#    port 25/143/etc. on the public interface and one fails to start.
# ─────────────────────────────────────────────────────────────────────────────

let
  unit = "mail";
  cfg = config.server.infra.${unit};
  srv = config.server;

  mailFqdn = "mail.${srv.domain}";

  # Matches the base DN computation in lldap.nix so we don't have to duplicate
  # it as a config option.  E.g. "example.com" → "dc=example,dc=com".
  lldapBaseDn = lib.concatMapStringsSep "," (dc: "dc=" + dc) (lib.splitString "." srv.domain);

  extractCerts = pkgs.writeShellApplication {
    name = "mail-cert-extract";
    runtimeInputs = [
      pkgs.jq
      pkgs.coreutils
    ];
    text = ''
      CERT_JSON=/var/lib/traefik/cert.json
      OUT_DIR=/run/mail-certs

      if [[ ! -f "$CERT_JSON" ]]; then
        echo "mail-cert-extract: $CERT_JSON not found, skipping" >&2
        exit 0
      fi

      jq -r '
        .letsencrypt.Certificates[]
        | select(.domain.main == "*.${srv.domain}")
        | .certificate
      ' "$CERT_JSON" | base64 -d > "$OUT_DIR/fullchain.pem.tmp"

      jq -r '
        .letsencrypt.Certificates[]
        | select(.domain.main == "*.${srv.domain}")
        | .key
      ' "$CERT_JSON" | base64 -d > "$OUT_DIR/privkey.pem.tmp"

      if [[ -s "$OUT_DIR/fullchain.pem.tmp" && -s "$OUT_DIR/privkey.pem.tmp" ]]; then
        mv "$OUT_DIR/fullchain.pem.tmp" "$OUT_DIR/fullchain.pem"
        mv "$OUT_DIR/privkey.pem.tmp"   "$OUT_DIR/privkey.pem"
        chown root:mail-cert "$OUT_DIR/fullchain.pem" "$OUT_DIR/privkey.pem"
        chmod 644 "$OUT_DIR/fullchain.pem"
        chmod 640 "$OUT_DIR/privkey.pem"
        echo "mail-cert-extract: certificates updated"
        systemctl is-active --quiet postfix  && systemctl reload postfix  || true
        systemctl is-active --quiet dovecot2 && systemctl reload dovecot2 || true
      else
        echo "mail-cert-extract: extraction produced empty files, aborting" >&2
        rm -f "$OUT_DIR/fullchain.pem.tmp" "$OUT_DIR/privkey.pem.tmp"
        exit 1
      fi
    '';
  };

in
{
  imports = [
    inputs.cnixpost.nixosModules.default
  ];

  options.server.infra.${unit} = {

    enable = lib.mkEnableOption "mail server (Postfix + Dovecot + Rspamd + ClamAV)";

    accounts = lib.mkOption {
      default = { };
      description = "Virtual mail accounts. Keyed by full address (user@domain).";
      example = lib.literalExpression ''
        {
          "alice@example.com" = {
            hashedPasswordFile = config.age.secrets."mail-alice-pw".path;
            quota              = "10G";
            aliases            = [ "postmaster@example.com" "abuse@example.com" ];
          };
        }
      '';
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            hashedPasswordFile = lib.mkOption { type = lib.types.path; };
            quota = lib.mkOption {
              type = lib.types.str;
              default = "2G";
            };
            aliases = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
            };
            sendOnly = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
          };
        }
      );
    };

    extraDomains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional virtual domains beyond the primary domain.";
    };

    dkimSelector = lib.mkOption {
      type = lib.types.str;
      default = "mail";
      description = "DKIM selector. DNS: <selector>._domainkey.<domain>";
    };

    spamScoreAddHeader = lib.mkOption {
      type = lib.types.float;
      default = 4.0;
    };
    spamScoreGreylist = lib.mkOption {
      type = lib.types.float;
      default = 6.0;
    };
    spamScoreReject = lib.mkOption {
      type = lib.types.float;
      default = 15.0;
    };

    messageSizeLimit = lib.mkOption {
      type = lib.types.int;
      default = 52428800;
      description = "Max message size in bytes (default: 50 MiB).";
    };

    clamav.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ClamAV. Disable on hosts with < 1.5 GiB RAM.";
    };

    debug = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    mtaSts = {
      enable = lib.mkEnableOption "MTA-STS policy publication (RFC 8461)";
      mode = lib.mkOption {
        type = lib.types.enum [
          "testing"
          "enforce"
          "none"
        ];
        default = "testing";
      };
      policyId = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "20240601120000";
        description = "Increment on every policy change. Convention: YYYYMMDDHHMMSS.";
      };
      mxHosts = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "mail.example.com" ];
      };
      maxAge = lib.mkOption {
        type = lib.types.int;
        default = 604800;
      };
      enableOutboundCheck = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable postfix-mta-sts-resolver for outbound MTA-STS enforcement.";
      };
    };

    relay = {
      enable = lib.mkEnableOption "relay outbound mail through a smarthost";
      host = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 587;
      };
      username = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
      };
    };

    lldap.enable = lib.mkEnableOption "authenticate mail users against the local lldap instance";
  };

  config = lib.mkIf cfg.enable {

    # ── age secrets ───────────────────────────────────────────────────────
    age.secrets = {
      mailRedisPw = {
        file = "${self}/secrets/mailRedisPw.age";
        owner = "rspamd";
        group = "rspamd";
        mode = "0440";
      };
      mailRspamdCtrlPw = {
        file = "${self}/secrets/mailRspamdCtrlPw.age";
        owner = "rspamd";
        group = "rspamd";
        mode = "0440";
      };
    };

    # ── mail-cert group ───────────────────────────────────────────────────
    #
    # Both postfix and dovecot2 read the private key extracted from Traefik.
    # A shared group with mode 640 avoids needing setfacl or toggling chown.
    users.groups.mail-cert = { };
    users.users.postfix.extraGroups = [ "mail-cert" ];
    users.users.dovecot2.extraGroups = [ "mail-cert" ];

    # ── Certificate extraction ─────────────────────────────────────────────
    systemd.tmpfiles.rules = [
      "d /run/mail-certs 0750 root mail-cert - -"
    ];

    # Watches Traefik's cert store and re-extracts on every write (i.e. renewal).
    systemd.paths.mail-cert-extract = {
      wantedBy = [ "multi-user.target" ];
      pathConfig = {
        PathChanged = "/var/lib/traefik/cert.json";
        Unit = "mail-cert-extract.service";
      };
    };

    # Type = oneshot WITHOUT RemainAfterExit = true.
    # RemainAfterExit keeps the service "active" after first run, which prevents
    # the path unit from re-triggering it on subsequent cert.json changes.
    # Without it, each path event restarts the (already-exited) service cleanly.
    systemd.services.mail-cert-extract = {
      description = "Extract mail TLS certificates from Traefik cert store";
      after = [
        "traefik.service"
        "network-online.target"
      ];
      wants = [
        "traefik.service"
        "network-online.target"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe extractCerts;
      };
    };

    # Postfix and Dovecot wait for certs before starting.
    # ConditionPathExists causes systemd to skip starting the service entirely
    # until the cert file is present, rather than starting and immediately failing.
    systemd.services.postfix = {
      after = lib.mkAfter [ "mail-cert-extract.service" ];
      wants = lib.mkAfter [ "mail-cert-extract.service" ];
      unitConfig.ConditionPathExists = "/run/mail-certs/fullchain.pem";
    };
    systemd.services.dovecot2 = {
      after = lib.mkAfter [ "mail-cert-extract.service" ];
      wants = lib.mkAfter [ "mail-cert-extract.service" ];
      unitConfig.ConditionPathExists = "/run/mail-certs/fullchain.pem";
    };

    # ── cnixpost wiring ───────────────────────────────────────────────────
    cnixpost = {
      enable = true;
      fqdn = mailFqdn;
      primaryDomain = srv.domain;
      extraDomains = cfg.extraDomains;

      certificateFile = "/run/mail-certs/fullchain.pem";
      keyFile = "/run/mail-certs/privkey.pem";

      accounts = cfg.accounts;
      dkimSelector = cfg.dkimSelector;

      redisPasswordFile = config.age.secrets.mailRedisPw.path;
      rspamdControllerPasswordFile = config.age.secrets.mailRspamdCtrlPw.path;

      spamScoreAddHeader = cfg.spamScoreAddHeader;
      spamScoreGreylist = cfg.spamScoreGreylist;
      spamScoreReject = cfg.spamScoreReject;

      messageSizeLimit = cfg.messageSizeLimit;
      clamav.enable = cfg.clamav.enable;
      debug = cfg.debug;

      fail2ban = {
        enable = true;
        maxRetry = 5;
        banTime = "1h";
        findTime = "10m";
      };

      mtaSts = {
        inherit (cfg.mtaSts)
          enable
          mode
          policyId
          mxHosts
          maxAge
          enableOutboundCheck
          ;
      };

      relay = {
        inherit (cfg.relay)
          enable
          host
          port
          username
          passwordFile
          ;
      };

      # ── lldap integration ──────────────────────────────────────────────
      #
      # lldap listens on loopback port 3890 with no TLS (safe for local use).
      # auth_bind = yes: Dovecot binds to LDAP as the user directly, so no
      # service account or bind password is needed.
      # staticUserdb = true: lldap does not store homeDirectory/uidNumber/gidNumber;
      # all mail users are mapped to the vmail system account instead.
      #
      # Accounts defined in server.infra.mail.accounts still control which
      # addresses Postfix accepts and at what quota.  hashedPasswordFile may
      # be left null for those accounts — authentication goes through lldap.
      ldap = lib.mkIf cfg.lldap.enable {
        enable = true;
        uri = "ldap://127.0.0.1:3890";
        base = lldapBaseDn;
        userDnTemplate = "uid=%u,ou=people,${lldapBaseDn}";
        staticUserdb = true;
        passFilter = "(uid=%u)";
        # No bindDN/bindPasswordFile — auth_bind_userdn constructs the DN
        # directly; no initial search bind is required.
      };
    };

    # ── Traefik: entrypoints ──────────────────────────────────────────────
    services.traefik.staticConfigOptions.entryPoints = {
      smtp.address = ":25";
      submission.address = ":587";
      submissions.address = ":465";
      imap.address = ":143";
      imaps.address = ":993";
      sieve.address = ":4190";
    };

    # ── Traefik: TCP routers + services with PROXY protocol v2 ────────────
    #
    # proxyProtocol.version = 2 prepends a PROXY v2 header to every forwarded
    # TCP connection so backends see the real client IP.
    #
    # For TLS-passthrough routers (imaps, submissions): the PROXY header is
    # sent at the TCP level before the TLS ClientHello.  Postfix
    # (smtpd_upstream_proxy_protocol=haproxy) and Dovecot (haproxy=yes on the
    # listener) both consume the header before starting TLS negotiation.
    services.traefik.dynamicConfigOptions.tcp = {
      routers = {
        smtp-in = {
          entryPoints = [ "smtp" ];
          rule = "HostSNI(`*`)";
          service = "postfix-smtp";
        };
        submission-starttls = {
          entryPoints = [ "submission" ];
          rule = "HostSNI(`*`)";
          service = "postfix-submission";
        };
        submissions = {
          entryPoints = [ "submissions" ];
          rule = "HostSNI(`${mailFqdn}`)";
          service = "postfix-submissions";
          tls.passthrough = true;
        };
        imap-starttls = {
          entryPoints = [ "imap" ];
          rule = "HostSNI(`*`)";
          service = "dovecot-imap";
        };
        imaps = {
          entryPoints = [ "imaps" ];
          rule = "HostSNI(`${mailFqdn}`)";
          service = "dovecot-imaps";
          tls.passthrough = true;
        };
        sieve-tcp = {
          entryPoints = [ "sieve" ];
          rule = "HostSNI(`*`)";
          service = "dovecot-sieve";
        };
      };

      services = {
        postfix-smtp.loadBalancer = {
          servers = [ { address = "127.0.0.1:25"; } ];
          proxyProtocol.version = 2;
        };
        postfix-submission.loadBalancer = {
          servers = [ { address = "127.0.0.1:587"; } ];
          proxyProtocol.version = 2;
        };
        postfix-submissions.loadBalancer = {
          servers = [ { address = "127.0.0.1:465"; } ];
          proxyProtocol.version = 2;
        };
        dovecot-imap.loadBalancer = {
          servers = [ { address = "127.0.0.1:143"; } ];
          proxyProtocol.version = 2;
        };
        dovecot-imaps.loadBalancer = {
          servers = [ { address = "127.0.0.1:993"; } ];
          proxyProtocol.version = 2;
        };
        dovecot-sieve.loadBalancer = {
          servers = [ { address = "127.0.0.1:4190"; } ];
          proxyProtocol.version = 2;
        };
      };
    };

    # ── Traefik: HTTP routes ───────────────────────────────────────────────
    services.traefik.dynamicConfigOptions.http = lib.mkMerge [
      # Rspamd web UI — protected by authentik SSO + controller password
      {
        routers.rspamd = {
          entryPoints = [ "websecure" ];
          rule = "Host(`rspamd.${srv.domain}`)";
          service = "rspamd-svc";
          tls.certResolver = "letsencrypt";
          middlewares = [ "authentik@file" ];
        };
        services.rspamd-svc.loadBalancer.servers = [
          { url = "http://localhost:11334"; }
        ];
      }

      # MTA-STS policy — routes to nginx on loopback; wildcard cert covers
      # mta-sts.<domain> so no separate ACME cert is needed.
      (lib.mkIf cfg.mtaSts.enable {
        routers.mta-sts = {
          entryPoints = [ "websecure" ];
          rule = "Host(`mta-sts.${srv.domain}`)";
          service = "mta-sts-svc";
          tls.certResolver = "letsencrypt";
        };
        services.mta-sts-svc.loadBalancer.servers = [
          { url = "http://127.0.0.1:8089"; }
        ];
      })
    ];

    environment.systemPackages = with pkgs; [
      jq
      swaks
      openssl
      xxd
    ];
  };
}
