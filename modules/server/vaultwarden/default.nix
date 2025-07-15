# yanked from @fufexan
{
  config,
  self,
  lib,
  ...
}: let
  inherit (config.networking) domain;
  inherit (lib) mkIf mkEnableOption;
  vcfg = config.services.vaultwarden.config;
  cfg = config.server.vaultwarden;
in {
  options = {
    home.server.vaultwarden.enable = mkEnableOption "Enables vaultwarden";
  };
  config = mkIf cfg.enable {
    age.secrets.vaultwarden-env = {
      file = "${self}/secrets/vaultwarden-env.age";
      owner = "vaultwarden";
      mode = "400";
    };

    # allow SMTP
    # networking.firewall.allowedTCPPorts = [587];

    # this forces the system to create backup folder
    systemd.services.backup-vaultwarden.serviceConfig = {
      User = "root";
      Group = "root";
    };

    services.caddy.virtualHosts."vault.cnst.dev".extraConfig = ''
      encode zstd gzip
      reverse_proxy ${vcfg.ROCKET_ADDRESS}:${toString vcfg.ROCKET_PORT} {
        header_up X-Real-IP {remote_host}
        # Use this instead, if using Cloudflare's proxy
        # header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
      }
    '';

    services.vaultwarden = {
      enable = true;
      environmentFile = config.age.secrets.vaultwarden-env.path;

      backupDir = "/var/backup/vaultwarden";

      config = {
        DOMAIN = "https://vault.${domain}";
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;

        extendedLogging = true;
        invitationsAllowed = false;
        showPasswordHint = false;

        useSyslog = true;
        logLevel = "warn";

        signupsAllowed = false;
        signupsDomainsWhitelist = domain;
        signupsVerify = true;
      };
    };
  };
}
