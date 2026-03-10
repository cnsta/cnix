{
  config,
  lib,
  ...
}:
with lib;
let
  unit = "affine";
  srv = config.server;
  cfg = config.server.services.${unit};
in
{
  options.services.affine = {
    rev = mkOption {
      type = types.str;
      default = "stable";
      description = "Image revision for AFFiNE (stable, beta, canary)";
    };
    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/affine";
      description = "Base data directory for AFFiNE storage";
    };
  };

  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      affineEnvironment.file = "${self}/secrets/affineEnvironment.age";
    };

    system.activationScripts.affine-dirs = ''
      mkdir -p -m 0755 ${cfg.dataDir}/{storage,config,redis}
      mkdir -p -m 0700 ${cfg.dataDir}/postgres
    '';

    virtualisation.oci-containers.containers = {
      affine = {
        image = "ghcr.io/toeverything/affine:${cfg.rev}";
        ports = [ "127.0.0.1:${toString cfg.port}:3010" ];
        dependsOn = [
          "affine-postgres"
          "affine-redis"
          "affine-migration"
        ];
        volumes = [
          "${cfg.dataDir}/storage:/root/.affine/storage"
          "${cfg.dataDir}/config:/root/.affine/config"
        ];
        environment = {
          AFFINE_REVISION = "stable";
          AFFINE_SERVER_PORT = cfg.port;
          AFFINE_SERVER_HOST = "affine.${srv.www.url}";
          AFFINE_SERVER_HTTPS = "true";
          AFFINE_INDEXER_ENABLED = "false";
          REDIS_SERVER_HOST = "affine-redis";
          DATABASE_URL = "postgresql://${DB_USERNAME}:${DB_PASSWORD}@postgres:5432/${DB_DATABASE: -affine}";
        };
        environmentFiles = config.age.secrets.affineEnvironment.path;
      };

      affine-postgres = {
        image = "pgvector/pgvector:pg16";
        volumes = [
          "${cfg.dataDir}/postgres:/var/lib/postgresql/data"
        ];
        environment = {
          POSTGRES_INITDB_ARGS = "--data-checksums";
        };
        environmentFiles = config.age.secrets.affineEnvironment.path;
        extraOptions = [
          "--health-cmd=pg_isready -U ${DB_USERNAME} -d ${DB_DATABASE}"
          "--health-interval=10s"
          "--health-timeout=5s"
          "--health-retries=5"
        ];
      };

      affine-redis = {
        image = "redis:7";
        volumes = [
          "${cfg.dataDir}/redis:/data"
        ];
        networks = [ "affine-net" ];
        extraOptions = [
          "--health-cmd=redis-cli --raw incr ping"
          "--health-interval=10s"
          "--health-timeout=5s"
          "--health-retries=5"
        ];
      };

      affine-migration = {
        image = "ghcr.io/toeverything/affine:${cfg.rev}";
        dependsOn = [
          "affine-postgres"
          "affine-redis"
        ];
        volumes = [
          "${cfg.dataDir}/storage:/root/.affine/storage"
          "${cfg.dataDir}/config:/root/.affine/config"
        ];
        cmd = [
          "sh"
          "-c"
          "node ./scripts/self-host-predeploy.js"
        ];
        environment = {
          REDIS_SERVER_HOST = "affine-redis";
          DATABASE_URL = "postgresql://${DB_USERNAME}:${DB_PASSWORD}@postgres:5432/${DB_DATABASE: -affine}";
          AFFINE_INDEXER_ENABLED = "false";
        };
        environmentFiles = config.age.secrets.affineEnvironment.path;
      };
    };
  };
}
