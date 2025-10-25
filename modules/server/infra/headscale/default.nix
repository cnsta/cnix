{
  config,
  lib,
  self,
  ...
}:
with lib; let
  cfg = config.server.infra.headscale;
  srv = config.server.infra;
in {
  options.server.infra.headscale = {
    enable = mkEnableOption "Enable headscale server configuration";
    url = lib.mkOption {
      type = lib.types.str;
      default = "hs.${srv.www.url}";
    };
    port = lib.mkOption {
      type = lib.types.port;
      description = "The local port the service runs on";
    };
  };
  config = mkIf cfg.enable {
    # age.secrets.sobotkaHsAuth.file = "${self}/secrets/sobotkaHsAuth.age";

    services = {
      headscale = {
        enable = true;
        port = cfg.port;
        settings = {
          server_url = "http://${cfg.url}";

          prefixes = {
            v4 = "100.64.0.0/10";
            v6 = "fd7a:115c:a1e0::/48";
            allocation = "random";
          };

          dns = {
            magic_dns = true;
            base_domain = "ts.cnst.dev";
            override_local_dns = true;
            nameservers = {
              global = [
                "192.168.88.1"
                "192.168.88.69"
              ];
              split = {
              };
            };

            # oidc = {
            #   issuer = "https://auth.cnst.dev/oauth2/openid/headscale";
            #   client_id = "headscale";
            #   client_secret_path = config.age.secrets.headscaleSecret.path;
            # };
          };
        };
      };
      traefik = {
        dynamicConfigOptions = {
          http = {
            services = {
              auth.loadBalancer.servers = [
                {
                  url = "http://localhost:8581";
                }
              ];
            };

            routers = {
              headscale = {
                entryPoints = ["websecure"];
                rule = "Host(`${cfg.url}`)";
                service = "headscale";
                tls.certResolver = "letsencrypt";
              };
            };
          };
        };
      };
    };
  };
}
