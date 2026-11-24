{
  config,
  lib,
  clib,
  self,
  ...
}: let
  unit = "aurral";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
  url = clib.server.mkUrl config cfg;
  autheliaUrl = clib.server.autheliaUrl config cfg;
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets.aurralEnvironment.file = self + "/secrets/aurralEnvironment.age";

    systemd.tmpfiles.rules = [
      "d ${cfg.configDir} 0755 ${srv.user} ${srv.group} - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/lklynet/aurral:latest";
        autoStart = true;
        ports = ["127.0.0.1:${toString cfg.port}:3001"];
        environment = {
          inherit (clib.server.containerEnv config) TZ PUID PGID;
          BRAINZMASH_BASE_URL = "api.lidarr.audio/api/v0.4";

          AURRAL_PUBLIC_URL = url;
          OIDC_ENABLED = "true";
          OIDC_ISSUER = autheliaUrl;
          OIDC_CLIENT_ID = unit;
          OIDC_REDIRECT_URI = "${url}/sso/callback";
          OIDC_SCOPES = "openid profile email groups";
          OIDC_GROUPS_CLAIM = "groups";
          OIDC_ADMIN_GROUPS = "admins";
          OIDC_LOGOUT_URL = "${autheliaUrl}/logout";
        };
        environmentFiles = [config.age.secrets.aurralEnvironment.path];
        volumes = [
          "${cfg.configDir}:/config:rw"
          "/mnt/data/media/music:/data/media/music:rw"
          "/mnt/data/downloads:/data/downloads:rw"
        ];
      };
    };
  };
}
