{
  config,
  lib,
  self,
  ...
}:
with lib;
let
  unit = "miniflux";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
in
{
  config = mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      minifluxEnvironment = {
        file = (self + "/secrets/minifluxEnvironment.age");
        mode = "0400";
      };
      minifluxPgPwd = {
        file = (self + "/secrets/minifluxPgPwd.age");
        mode = "0400";
      };
    };

    cnix.server.infra.postgresql.databases = [
      {
        database = unit;
        passwordFile = config.age.secrets.minifluxPgPwd.path;
      }
    ];

    virtualisation.oci-containers.containers = {
      miniflux = {
        image = "miniflux/miniflux:latest";
        autoStart = true;
        ports = [
          "${toString cfg.port}:8080"
        ];
        environmentFiles = [ config.age.secrets.minifluxEnvironment.path ];
        extraOptions = [
          "--add-host=host.containers.internal:host-gateway"
        ];
      };
    };
  };
}
