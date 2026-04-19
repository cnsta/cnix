{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types mkOption;
  cfg = config.server.infra.postgresql;
  database =
    { name, ... }:
    {
      options = {
        database = mkOption {
          type = types.str;
          description = "Database name";
        };
        extraUsers = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "List of extra users with access to this database.";
        };
        extensions = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "List of extensions to install and enable.";
        };
      };
    };

  allUsers = lib.unique (
    lib.concatMap ({ database, extraUsers, ... }: [ database ] ++ extraUsers) cfg.databases
  );
in
{
  options.server.infra.postgresql.databases = mkOption {
    type = types.listOf (types.submodule database);
    default = [ ];
    description = "List of databases to set up.";
  };

  config = lib.mkIf (cfg.databases != [ ]) {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_18;
      extensions = lib.filter (x: x != null) (
        lib.concatMap (
          { extensions, ... }: map (ext: config.services.postgresql.package.pkgs.${ext} or null) extensions
        ) cfg.databases
      );
      authentication = lib.mkForce ''
        local all postgres peer
        ${lib.concatMapStringsSep "\n" (
          { database, extraUsers, ... }:
          lib.concatMapStringsSep "\n" (u: "local ${database} ${u} peer") ([ database ] ++ extraUsers)
        ) cfg.databases}
      '';
    };

    systemd.services = {
      postgres-setup =
        let
          pgsql = config.services.postgresql;

          createRoles = lib.concatMapStringsSep "\n" (user: ''
            $PSQL -tAc "SELECT 1 FROM pg_roles WHERE rolname='${user}'" | grep -q 1 \
              || $PSQL -c 'CREATE USER "${user}"'
          '') allUsers;

          setupDb =
            {
              database,
              extensions,
              extraUsers,
              ...
            }:
            let
              createExtensionsSql = lib.concatMapStringsSep "; " (
                ext: ''CREATE EXTENSION IF NOT EXISTS "${ext}"''
              ) extensions;
              createExtensionsIfAny = lib.optionalString (extensions != [ ]) ''
                $PSQL -d '${database}' -c '${createExtensionsSql}'
              '';
              grantSql = lib.concatMapStringsSep "\n" (user: ''
                $PSQL -d '${database}' -c 'GRANT ALL ON ALL TABLES IN SCHEMA public TO "${user}";'
                $PSQL -d '${database}' -c 'GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO "${user}";'
                $PSQL -d '${database}' -c 'ALTER DEFAULT PRIVILEGES FOR ROLE "${database}" IN SCHEMA public GRANT ALL ON TABLES TO "${user}";'
                $PSQL -d '${database}' -c 'ALTER DEFAULT PRIVILEGES FOR ROLE "${database}" IN SCHEMA public GRANT ALL ON SEQUENCES TO "${user}";'
              '') extraUsers;
            in
            ''
              if ! $PSQL -c "SELECT 1 FROM pg_database WHERE datname = '${database}'" | grep --quiet 1; then
                $PSQL -c 'CREATE DATABASE "${database}" WITH OWNER = "${database}"'
                ${createExtensionsIfAny}
              fi
              ${grantSql}
            '';
        in
        {
          after = [ "postgresql.service" ];
          requires = [ "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];
          path = [ pgsql.package ];

          script = ''
            set -eu
            PSQL="${pkgs.util-linux}/bin/runuser -u ${pgsql.superUser} -- psql --port=${
              toString (pgsql.settings.port or 5432)
            } --tuples-only --no-align"

            ${createRoles}

            ${lib.concatMapStringsSep "\n" setupDb cfg.databases}
          '';

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
        };

      postgresql.serviceConfig.MemoryDenyWriteExecute = true;
    };
  };
}
