{
  lib,
  config,
  pkgs,
  self,
  myLib,
  ...
}: let
  inherit (myLib) mkVirtualHost;
  inherit (lib) mkEnableOption mkIf types;

  unit = "nginx";
  cfg = config.server.nginx;
  srv = config.server;
in {
  options.server.nginx = {
    enable = mkEnableOption "Enable global NGINX reverse proxy with ACME";
  };

  config = mkIf cfg.enable {
    age.secrets = {
      nginxEnv = {
        file = "${self}/secrets/nginxEnv.age";
      };
    };

    networking.firewall.allowedTCPPorts = [80 443];

    security = {
      acme = {
        acceptTerms = true;
        defaults.email = config.server.email;
        certs.${srv.domain} = {
          reloadServices = ["nginx.service"];
          domain = "${srv.domain}";
          extraDomainNames = ["*.${srv.domain}"];
          dnsProvider = "cloudflare";
          dnsPropagationCheck = true;
          group = config.services.nginx.group;
          environmentFile = config.age.secrets.nginxEnv.path;
        };
      };
      dhparams = {
        enable = true;
        params.nginx = {};
      };
    };

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      resolver.addresses = config.networking.nameservers;
      sslDhparam = config.security.dhparams.params.nginx.path;
      appendHttpConfig = ''
        proxy_headers_hash_max_size 512;
        proxy_headers_hash_bucket_size 128;
      '';

      virtualHosts = let
        labDomain = "cnix.dev";
        labCert = {
          useACMEHost = "cnix.dev";
          forceSSL = true;
        };
      in {
        # proxies on domain with https, only accessible within local network
        "${labDomain}" =
          labCert
          // {
            locations."/".proxyPass = "http://127.0.0.1:${toString config.services.homepage-dashboard.listenPort}";
          };
      };
    };
    users.users.nginx.extraGroups = ["acme"];
  };
}
