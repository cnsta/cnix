{
  config,
  lib,
  self,
  pkgs,
  inputs,
  ...
}:

let
  unit = "cnixpost";
  cfg = config.server.infra.${unit};
  srv = config.server;

  mailFqdn = "mail.${srv.domain}";
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
        echo "mail-cert-extract: $CERT_JSON not found yet" >&2
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
      else
        echo "mail-cert-extract: extraction produced empty files" >&2
        rm -f "$OUT_DIR/fullchain.pem.tmp" "$OUT_DIR/privkey.pem.tmp"
        exit 1
      fi
    '';
  };
in
{
  imports = [ inputs.cnixpost.nixosModules.default ];

  options.server.infra.${unit} = {
    enable = lib.mkEnableOption "mail server (Postfix + Dovecot + Rspamd + ClamAV)";

    accounts = lib.mkOption {
      default = { };
      description = "Virtual mail accounts keyed by full address (user@domain).";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
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
    };

    dkimSelector = lib.mkOption {
      type = lib.types.str;
      default = "mail";
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
    };

    clamav.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
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
      };
      mxHosts = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
      enableOutboundCheck = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {

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

    # Cert extraction from Traefik
    systemd.paths.mail-cert-extract = {
      wantedBy = [ "multi-user.target" ];
      pathConfig = {
        PathChanged = "/var/lib/traefik/cert.json";
        Unit = "mail-cert-extract.service";
        TriggerLimitIntervalSec = 10;
        TriggerLimitBurst = 3;
      };
    };

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
      startLimitIntervalSec = 60;
      startLimitBurst = 5;
    };

    systemd.services.mail-cert-reload = {
      description = "Reload mail services after TLS cert update";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.systemd}/bin/systemctl reload-or-try-restart postfix dovecot2 || true'";
      };
    };

    systemd.paths.mail-cert-reload = {
      wantedBy = [ "multi-user.target" ];
      pathConfig = {
        PathModified = "/run/mail-certs/fullchain.pem";
        Unit = "mail-cert-reload.service";
        TriggerLimitIntervalSec = 30;
        TriggerLimitBurst = 2;
      };
    };

    cnixpost = {
      enable = true;
      fqdn = mailFqdn;
      primaryDomain = srv.domain;
      extraDomains = cfg.extraDomains;

      certificateFile = "/run/mail-certs/fullchain.pem";
      keyFile = "/run/mail-certs/privkey.pem";
      certWatchService = "mail-cert-extract.service";

      inherit (cfg)
        accounts
        dkimSelector
        spamScoreAddHeader
        spamScoreGreylist
        spamScoreReject
        messageSizeLimit
        debug
        ;
      clamav.enable = cfg.clamav.enable;

      redisPasswordFile = config.age.secrets.mailRedisPw.path;
      rspamdControllerPasswordFile = config.age.secrets.mailRspamdCtrlPw.path;

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
          enableOutboundCheck
          ;
      };

      lldap = {
        uri = "ldap://127.0.0.1:3890";
        base = lldapBaseDn;
        userDnTemplate = "uid=%n,ou=people,${lldapBaseDn}";
        bindPasswordFile = config.age.secrets.lldapAdminPasswordAuthelia.path;
      };
    };

    # Traefik TCP entrypoints and routing for mail
    services.traefik.staticConfigOptions.entryPoints = {
      smtp.address = ":25";
      submission.address = ":587";
      submissions.address = ":465";
      imap.address = ":143";
      imaps.address = ":993";
      sieve.address = ":4190";
    };

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
          servers = [ { address = "127.0.0.1:10025"; } ];
          proxyProtocol.version = 2;
        };
        postfix-submission.loadBalancer = {
          servers = [ { address = "127.0.0.1:10587"; } ];
          proxyProtocol.version = 2;
        };
        postfix-submissions.loadBalancer = {
          servers = [ { address = "127.0.0.1:10465"; } ];
          proxyProtocol.version = 2;
        };
        dovecot-imap.loadBalancer = {
          servers = [ { address = "127.0.0.1:10143"; } ];
          proxyProtocol.version = 2;
        };
        dovecot-imaps.loadBalancer = {
          servers = [ { address = "127.0.0.1:10993"; } ];
          proxyProtocol.version = 2;
        };
        dovecot-sieve.loadBalancer = {
          servers = [ { address = "127.0.0.1:10419"; } ];
          proxyProtocol.version = 2;
        };
      };
    };

    services.traefik.dynamicConfigOptions.http = lib.mkMerge [
      {
        routers.rspamd = {
          entryPoints = [ "websecure" ];
          rule = "Host(`rspamd.${srv.domain}`)";
          service = "rspamd-svc";
          tls.certResolver = "letsencrypt";
          middlewares = [ "authelia@file" ];
        };
        services.rspamd-svc.loadBalancer.servers = [
          { url = "http://localhost:11334"; }
        ];
      }

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

      (lib.mkIf config.cnixpost.autoconfig.enable {
        routers.autoconfig = {
          entryPoints = [ "websecure" ];
          rule = "Host(`autoconfig.${srv.domain}`)";
          service = "autoconfig-svc";
          tls.certResolver = "letsencrypt";
        };
        routers.autodiscover = {
          entryPoints = [ "websecure" ];
          rule = "Host(`autodiscover.${srv.domain}`)";
          service = "autoconfig-svc";
          tls.certResolver = "letsencrypt";
        };
        services.autoconfig-svc.loadBalancer.servers = [
          { url = "http://127.0.0.1:8090"; }
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
