{
  config,
  lib,
  self,
  pkgs,
  ...
}:
let
  unit = "hoppscotch";
  srv = config.server;
  cfg = config.server.services.${unit};
in
{
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      hoppscotchEnvironment = {
        file = (self + "/secrets/hoppscotchEnvironment.age");
        mode = "0400";
        owner = "root";
      };
      hoppscotchPgPwd = {
        file = (self + "/secrets/hoppscotchPgPwd.age");
        mode = "0400";
        owner = "root";
      };
    };

    server.infra.postgresql.databases = [
      {
        database = unit;
        passwordFile = lib.removeSuffix "\n" config.age.secrets.hoppscotchPgPwd.path;
      }
    ];

    virtualisation.oci-containers.containers = {
      hoppscotch = {
        image = "hoppscotch/hoppscotch:latest";
        autoStart = true;
        ports = [
          "3080:8085"
        ];
        environmentFiles = [ config.age.secrets.hoppscotchEnvironment.path ];
        extraOptions = [
          "--add-host=host.containers.internal:host-gateway"
        ];
      };
    };

    systemd.services.hoppscotch-migrate = {
      description = "Hoppscotch database migrations";
      after = [
        "postgresql.service"
        "postgres-setup.service"
        "network-online.target"
      ];
      wants = [
        "postgresql.service"
        "postgres-setup.service"
        "network-online.target"
      ];
      before = [ "podman-hoppscotch.service" ];
      wantedBy = [ "podman-hoppscotch.service" ];
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        EnvironmentFile = config.age.secrets.hoppscotchEnvironment.path;
        ExecStart = pkgs.writeShellScript "hoppscotch-migrate" ''
          set -eu
          podman pull hoppscotch/hoppscotch:latest
          podman run --rm \
            --name hoppscotch-migrate \
            --add-host=host.containers.internal:host-gateway \
            --env-file=${config.age.secrets.hoppscotchEnvironment.path} \
            hoppscotch/hoppscotch:latest \
            pnpm --filter hoppscotch-backend exec prisma migrate deploy
        '';
        Restart = "on-failure";
        RestartSec = "30s";
      };
    };
  };
}
