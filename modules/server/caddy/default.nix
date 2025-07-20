{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.server.caddy;
in {
  options = {
    server.caddy.enable = mkEnableOption "Enables caddy";
  };
  config = mkIf cfg.enable {
    networking.firewall = let
      ports = [80 443];
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
        environmentFile = config.age.secrets.cloudflareDnsCredentials.path;
      };
    };

    services.caddy = {
      enable = true;
      globalConfig = ''
        servers { trusted_proxies static private_ranges }
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
      };
    };
  };
}
