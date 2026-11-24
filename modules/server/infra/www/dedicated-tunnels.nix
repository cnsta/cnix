{
  lib,
  clib,
  config,
  self,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkMerge
    filterAttrs
    mapAttrs'
    mapAttrsToList
    nameValuePair
    trim
    ;

  dedicated =
    filterAttrs (
      _: svc: svc.enable && svc.exposure == "dedicated-tunnel"
    )
    config.cnix.server.services;

  secretFile = name: "${self}/secrets/${name}Cloudflared.age";
  tunnelIdFile = name: "${self}/secrets/${name}Cloudflared.tunnelId";
  tunnelIdOf = name: trim (builtins.readFile (tunnelIdFile name));
in {
  config = mkMerge [
    (mkIf (dedicated != {}) {
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
                    ${clib.server.mkFullDomain config svc}.service = clib.server.tunnelTarget svc;
                  }
                  // mapAttrs' (sub: url: nameValuePair "${sub}.${clib.server.mkDomain config svc}" {service = url;}) svc.ingress;
              }
          )
          dedicated;
      };
    })

    (mkIf config.services.cloudflared.enable {
      systemd.services =
        mapAttrs' (
          id: _:
            nameValuePair "cloudflared-tunnel-${id}" {
              startLimitIntervalSec = 0;
              serviceConfig.RestartSec = 5;
            }
        )
        config.services.cloudflared.tunnels;
    })
  ];
}
