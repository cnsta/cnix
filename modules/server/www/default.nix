{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.server.www;
  srv = config.server;
in {
  options.server.www = {
    enable = mkEnableOption {
      description = "Enable personal website";
    };
    url = mkOption {
      default = "";
      type = types.str;
      description = ''
        Public domain name to be used to access the server services via Caddy reverse proxy
      '';
    };
  };
  config = mkIf cfg.enable {
    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = cfg.url;
      extraConfig = ''
          handle_path /.well-known/webfinger {
          header Content-Type application/jrd+json
          respond `{
            "subject": "acct:adam@${cfg.url}",
            "links": [
              {
                "rel": "http://openid.net/specs/connect/1.0/issuer",
                "href": "https://login.${cfg.url}/realms/cnix"
              }
            ]
          }`
        }

        reverse_proxy http://127.0.0.1:8283
      '';
    };
  };
}
