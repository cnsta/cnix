{
  lib,
  config,
  self,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.cnix.server.infra.www;
in {
  imports = [./dedicated-tunnels.nix];

  options.cnix.server.infra.www = {
    enable = mkEnableOption {
      description = "Enable personal website";
    };
    url = mkOption {
      default = "";
      type = types.str;
      description = ''
        Public domain name to be used to access the server services via Traefik reverse proxy
      '';
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8283;
      description = "The port to host webservice on.";
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

  config = mkIf cfg.enable {
    age.secrets = {
      wwwCloudflared.file = "${self}/secrets/wwwCloudflared.age";
    };

    cnix.server.infra.anubis.sites.www = {
      host = cfg.url;
      target = "http://127.0.0.1:${toString cfg.port}";
      port = 8923;
    };

    services = {
      nginx = {
        enable = true;
        defaultListen = [
          {
            addr = "127.0.0.1";
            port = cfg.port;
          }
        ];
        virtualHosts = {
          "www" = {
            forceSSL = false;
            serverName = cfg.url;
            root = "/var/www";

            locations."= /.well-known/webfinger" = {
              extraConfig = ''
                default_type application/jrd+json;
                try_files /.well-known/webfinger =404;
              '';
            };

            locations."= /robots.txt" = {
              extraConfig = ''
                default_type text/plain;
                try_files /robots.txt =404;
              '';
            };

            locations."~ /\\.(?!well-known/)".extraConfig = "deny all;";
            locations."~ (bak|~)$".extraConfig = "deny all;";
            locations."^~ /jsbak/".extraConfig = "deny all;";
          };
        };
      };

      cloudflared = {
        enable = true;
        tunnels.${cfg.cloudflared.tunnelId} = {
          credentialsFile = cfg.cloudflared.credentialsFile;
          default = "http_status:404";
          ingress = let
            tunnelServices =
              lib.filterAttrs (
                _: svc: svc.enable && svc.exposure == "tunnel" && svc.subdomain != ""
              )
              config.cnix.server.services;
            autoIngress =
              lib.mapAttrs' (
                _: svc:
                  lib.nameValuePair "${svc.subdomain}.${cfg.url}" {
                    service = "http://127.0.0.1:${toString (
                      if svc.anubis.port != null
                      then svc.anubis.port
                      else svc.port
                    )}";
                  }
              )
              tunnelServices;
            extraIngress = lib.foldlAttrs (
              acc: _: svc:
                acc
                // lib.mapAttrs' (sub: url: lib.nameValuePair "${sub}.${cfg.url}" {service = url;}) svc.ingress
            ) {} (lib.filterAttrs (_: svc: svc.enable && svc.exposure != "dedicated-tunnel") config.cnix.server.services);
          in
            autoIngress
            // extraIngress;
        };
      };
    };
  };
}
