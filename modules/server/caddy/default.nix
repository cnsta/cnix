{
  self,
  pkgs,
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
    age.secrets.cloudflare-env = {
      file = "${self}/secrets/cloudflare-env.age";
      owner = "caddy";
      mode = "400";
    };
    networking.firewall = let
      ports = [80 443];
    in {
      allowedTCPPorts = ports;
      allowedUDPPorts = ports;
    };

    # security.acme = {
    #   acceptTerms = true;
    #   defaults.email = config.server.email;
    #   certs.${config.server.domain} = {
    #     reloadServices = ["caddy.service"];
    #     domain = "${config.server.domain}";
    #     extraDomainNames = ["*.${config.server.domain}"];
    #     dnsProvider = "cloudflare";
    #     dnsResolver = "1.1.1.1:53";
    #     dnsPropagationCheck = true;
    #     group = config.services.caddy.group;
    #     environmentFile = config.age.secrets.cloudflare-env.path;
    #   };
    # };

    services.caddy = {
      enable = true;
      # environmentFile = config.age.secrets.cloudflare-env.path;
      # package = self.packages.${pkgs.system}.caddy-with-plugins;
    };
  };
}
