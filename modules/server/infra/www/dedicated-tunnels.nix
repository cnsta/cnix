{
  lib,
  config,
  self,
  ...
}: let
  inherit
    (lib)
    mkIf
    filterAttrs
    mapAttrs'
    mapAttrsToList
    nameValuePair
    trim
    ;

  www = config.cnix.server.infra.www;

  dedicated =
    filterAttrs (
      _: svc: svc.enable && svc.exposure == "dedicated-tunnel"
    )
    config.cnix.server.services;

  secretFile = name: "${self}/secrets/${name}Cloudflared.age";
  tunnelIdFile = name: "${self}/secrets/${name}Cloudflared.tunnelId";
  tunnelIdOf = name: trim (builtins.readFile (tunnelIdFile name));
in {
  config = mkIf (dedicated != {}) {
    assertions =
      mapAttrsToList (name: _: {
        assertion =
          builtins.pathExists (secretFile name)
          && builtins.pathExists (tunnelIdFile name);
        message = ''
          cnix.server.services.${name}: exposure = "dedicated-tunnel" expects
          secrets/${name}Cloudflared.age and secrets/${name}Cloudflared.tunnelId
        '';
      })
      dedicated;

    age.secrets =
      mapAttrs' (
        name: _:
          nameValuePair "${name}Cloudflared" {file = secretFile name;}
      )
      dedicated;

    services.cloudflared = {
      enable = true;
      tunnels =
        mapAttrs' (
          name: svc:
            nameValuePair (tunnelIdOf name) {
              credentialsFile = config.age.secrets."${name}Cloudflared".path;
              default = "http_status:404";
              ingress =
                {
                  "${svc.subdomain}.${www.url}".service = "http://127.0.0.1:${toString svc.port}";
                }
                // mapAttrs' (sub: url: nameValuePair "${sub}.${www.url}" {service = url;}) svc.ingress;
            }
        )
        dedicated;
    };
  };
}
