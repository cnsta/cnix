# from @fufexan & @notthebee
{
  config,
  clib,
  lib,
  self,
  ...
}: let
  unit = "vaultwarden";
  cfg = config.cnix.server.services.${unit};
  domain = clib.server.mkFullDomain config cfg;
in {
  config = lib.mkIf cfg.enable {
    age.secrets = {
      vaultwardenEnvironment.file = "${self}/secrets/vaultwardenEnvironment.age";
    };

    cnix.server.infra.fail2ban.jails.${unit} = {
      serviceName = "${unit}";
      failRegex = ''^.*?Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$'';
    };

    services = {
      vaultwarden = {
        enable = true;
        environmentFile = config.age.secrets.vaultwardenEnvironment.path;

        backupDir = "/var/backup/vaultwarden";

        config = {
          DOMAIN = "https://${domain}";
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
