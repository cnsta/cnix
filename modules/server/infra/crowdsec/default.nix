{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe getExe' mkEnableOption mkIf mkOption optional types;

  cfg = config.cnix.server.infra.crowdsec;
  traefik = config.services.traefik;
  traefikLog = traefik.staticConfigOptions.accesslog.filepath or null;
  stateDir = "/var/lib/crowdsec/state";

  cs = config.services.crowdsec;
  cscli = "${getExe' cs.package "cscli"} -c=${(pkgs.formats.yaml {}).generate "crowdsec.yaml" cs.settings.general}";
  bouncerName = "crowdsec-firewall-bouncer";
  bouncerKey = "${stateDir}/firewall-bouncer.key";
in {
  options.cnix.server.infra.crowdsec = {
    enable = mkEnableOption ''
      CrowdSec: parses Traefik's access log and sshd, shares and pulls the community
      blocklist, and bans in nftables. Only bans traffic that reaches this host directly.
      Cloudflare-tunnelled requests all come from loopback and are whitelisted
    '';

    collections = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["crowdsecurity/postfix" "crowdsecurity/dovecot"];
      description = "Extra hub collections on top of the base set.";
    };

    acquisitions = mkOption {
      type = types.listOf types.attrs;
      default = [];
      example = [
        {
          source = "journalctl";
          journalctl_filter = ["_SYSTEMD_UNIT=postfix.service"];
          labels.type = "syslog";
        }
      ];
      description = "Extra log sources, in CrowdSec's acquisition format.";
    };
  };

  config = mkIf cfg.enable {
    services.crowdsec = {
      enable = true;
      autoUpdateService = true;

      hub.collections =
        [
          "crowdsecurity/linux" # sshd, private-range whitelist
          "crowdsecurity/base-http-scenarios"
          "crowdsecurity/http-cve"
          "crowdsecurity/whitelist-good-actors"
        ]
        ++ optional traefik.enable "crowdsecurity/traefik"
        ++ cfg.collections;

      localConfig = {
        acquisitions =
          [
            {
              source = "journalctl";
              journalctl_filter = ["_SYSTEMD_UNIT=sshd.service"];
              labels.type = "syslog";
            }
          ]
          ++ optional (traefik.enable && traefikLog != null) {
            source = "file";
            filenames = [traefikLog];
            labels.type = "traefik";
          }
          ++ cfg.acquisitions;

        profiles = [
          {
            name = "default_ip_remediation";
            filters = ["Alert.Remediation == true && Alert.GetScope() == \"Ip\""];
            decisions = [
              {
                type = "ban";
                duration = "4h";
              }
            ];
            on_success = "break";
          }
          {
            name = "default_range_remediation";
            filters = ["Alert.Remediation == true && Alert.GetScope() == \"Range\""];
            decisions = [
              {
                type = "ban";
                duration = "4h";
              }
            ];
            on_success = "break";
          }
        ];

        # crowdsecurity/whitelists covers RFC 1918 and loopback, not the tailnet.
        parsers.s02Enrich = [
          {
            name = "cnix/tailnet-whitelist";
            description = "Never ban tailnet peers";
            whitelist = {
              reason = "tailnet";
              cidr = ["100.64.0.0/10" "fd7a:115c:a1e0::/48"];
            };
          }
        ];
      };

      settings = {
        general.api.server = {
          enable = true;
          listen_uri = "127.0.0.1:8090";
        };
        lapi.credentialsFile = "${stateDir}/local_api_credentials.yaml";
        capi.credentialsFile = "${stateDir}/online_api_credentials.yaml";
      };
    };

    services.crowdsec-firewall-bouncer = {
      enable = true;
      registerBouncer.enable = false;
      secrets.apiKeyPath = bouncerKey;
    };

    systemd.tmpfiles.settings."11-crowdsec"."${stateDir}/online_api_credentials.yaml".f = {
      user = config.services.crowdsec.user;
      group = config.services.crowdsec.group;
      mode = "0600";
    };

    systemd.services.crowdsec.serviceConfig.ExecStartPost = getExe (pkgs.writeShellScriptBin "crowdsec-register-bouncer" ''
      set -eu
      umask 077
      if [ ! -s ${bouncerKey} ]; then
        ${getExe' pkgs.coreutils "tr"} -dc A-Za-z0-9 </dev/urandom | ${getExe' pkgs.coreutils "head"} -c 40 >${bouncerKey}
      fi
      if ! ${cscli} bouncers list -o json | ${getExe pkgs.jq} -e 'any(.[]?; .name == "${bouncerName}")' >/dev/null; then
        ${cscli} bouncers add ${bouncerName} -k "$(${getExe' pkgs.coreutils "cat"} ${bouncerKey})" >/dev/null
      fi
    '');

    users.users.${config.services.crowdsec.user}.extraGroups = optional traefik.enable traefik.group;
  };
}
