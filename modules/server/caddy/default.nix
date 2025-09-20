{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.server.caddy;

  getCloudflareCredentials = hostname:
    if hostname == "ziggy"
    then config.age.secrets.cloudflareDnsCredentialsZiggy.path
    else if hostname == "sobotka"
    then config.age.secrets.cloudflareDnsCredentials.path
    else throw "Unknown hostname: ${hostname}";
in {
  options = {
    server.caddy.enable = mkEnableOption "Enables caddy";
  };
  config = mkIf cfg.enable {
    networking.firewall = let
      ports = [
        80
        443
      ];
    in {
      allowedTCPPorts = ports;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = config.server.email;
      certs.${config.server.domain} = {
        reloadServices = ["caddy.service"];
        domain = "${config.server.domain}";
        extraDomainNames = ["*.${config.server.domain}"];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        group = config.services.caddy.group;
        environmentFile = getCloudflareCredentials config.networking.hostName;
      };
      certs.${config.server.domainPublic} = {
        reloadServices = ["caddy.service"];
        domain = "${config.server.domainPublic}";
        extraDomainNames = ["*.${config.server.domainPublic}"];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        group = config.services.caddy.group;
        environmentFile = getCloudflareCredentials config.networking.hostName;
      };
    };

    services.caddy = {
      enable = true;
      globalConfig = ''
        auto_https off
      '';
      virtualHosts = {
        "http://${config.server.domain}" = {
          extraConfig = ''
            redir https://{host}{uri}
          '';
        };
        "http://*.${config.server.domain}" = {
          extraConfig = ''
            redir https://{host}{uri}
          '';
        };

        "http://${config.server.domainPublic}" = {
          extraConfig = ''
            redir https://{host}{uri}
          '';
        };
        "http://*.${config.server.domainPublic}" = {
          extraConfig = ''
            redir https://{host}{uri}
          '';
        };
      };
    };
  };
}
