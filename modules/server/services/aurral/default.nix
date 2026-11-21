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
  url = "https://${clib.server.mkFullDomain config cfg}";
  autheliaUrl = "https://${clib.server.mkFullDomain config srv.services.authelia}";
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets.aurralEnvironment.file = self + "/secrets/aurralEnvironment.age";

    systemd.tmpfiles.rules = [
      "d /var/lib/aurral 0755 share share - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/lklynet/aurral:latest";
        autoStart = true;
        ports = ["127.0.0.1:${toString cfg.port}:3001"];
        environment = {
          TZ = "Europe/Stockholm";
          PUID = toString config.users.users.${srv.user}.uid;
          PGID = toString config.users.groups.${srv.group}.gid;
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
          "/var/lib/aurral:/config:rw"
          "/mnt/data/media/music:/data/media/music:rw"
          "/mnt/data/downloads:/data/downloads:rw"
        ];
      };
    };
  };
}
