# from @fufexan & @notthebee
{
  config,
  lib,
  self,
  ...
}: let
  unit = "vaultwarden";
  cfg = config.server.services.${unit};
  www = config.server.infra.www;
in {
  config = lib.mkIf cfg.enable {
    age.secrets = {
      vaultwardenCloudflared.file = "${self}/secrets/vaultwardenCloudflared.age";
      vaultwardenEnvironment.file = "${self}/secrets/vaultwardenEnvironment.age";
    };

    server.infra = {
      fail2ban = {
        jails = {
          vaultwarden = {
            serviceName = "${unit}";
            failRegex = ''^.*?Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$'';
          };
        };
      };
    };

    services = {
      cloudflared = {
        enable = true;
        tunnels.${cfg.cloudflared.tunnelId} = {
          credentialsFile = cfg.cloudflared.credentialsFile;
          default = "http_status:404";
          ingress."${cfg.url}".service = "http://localhost:${toString cfg.port}";
        };
      };

      vaultwarden = {
        enable = true;
        environmentFile = config.age.secrets.vaultwardenEnvironment.path;

        backupDir = "/var/backup/vaultwarden";

        config = {
          DOMAIN = "https://vault.${www.url}";
          SIGNUPS_ALLOWED = false;
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = cfg.port;
          IP_HEADER = "CF-Connecting-IP";

          logLevel = "warn";
          extendedLogging = true;
          useSyslog = true;
          invitationsAllowed = true;
          showPasswordHint = false;
        };
      };
    };
    systemd.services.backup-vaultwarden.serviceConfig = {
      User = "root";
      Group = "root";
    };
  };
}
