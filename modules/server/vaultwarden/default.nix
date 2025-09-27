# from @fufexan & @notthebee
{
  config,
  lib,
  self,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  vcfg = config.services.vaultwarden.config;
  cfg = config.server.vaultwarden;
in {
  options = {
    server.vaultwarden = {
      enable = mkEnableOption "Enables vaultwarden";
      url = lib.mkOption {
        type = lib.types.str;
        default = "${cfg.domain}";
      };
      cloudflared = {
        credentialsFile = lib.mkOption {
          type = lib.types.str;
          example = lib.literalExpression ''
            pkgs.writeText "cloudflare-credentials.json" '''
            {"AccountTag":"secret"."TunnelSecret":"secret","TunnelID":"secret"}
            '''
          '';
        };
        tunnelId = lib.mkOption {
          type = lib.types.str;
          example = "00000000-0000-0000-0000-000000000000";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    age.secrets = {
      vaultwardenCloudflared.file = "${self}/secrets/vaultwardenCloudflared.age";
      vaultwardenEnvironment.file = "${self}/secrets/vaultwardenEnvironment.age";
    };

    server = {
      fail2ban = lib.mkIf config.server.fail2ban.enable {
        jails = {
          vaultwarden = {
            serviceName = "vaultwarden";
            failRegex = "^.*Username or password is incorrect. Try again. IP: <HOST>. Username: <F-USER>.*</F-USER>.$";
          };
        };
      };
    };

    systemd.services.backup-vaultwarden.serviceConfig = {
      User = "root";
      Group = "root";
    };

    services = {
      vaultwarden = {
        enable = true;
        environmentFile = config.age.secrets.vaultwardenEnvironment.path;

        backupDir = "/var/backup/vaultwarden";

        config = {
          DOMAIN = "https://${cfg.url}";
          SIGNUPS_ALLOWED = false;
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
          IP_HEADER = "CF-Connecting-IP";

          logLevel = "warn";
          extendedLogging = true;
          useSyslog = true;
          invitationsAllowed = false;
          showPasswordHint = false;
        };
      };
      cloudflared = {
        enable = true;
        tunnels.${cfg.cloudflared.tunnelId} = {
          credentialsFile = cfg.cloudflared.credentialsFile;
          default = "http_status:404";
          ingress."${cfg.url}".service = "http://${vcfg.ROCKET_ADDRESS}:${toString vcfg.ROCKET_PORT}";
        };
      };
    };
  };
}
