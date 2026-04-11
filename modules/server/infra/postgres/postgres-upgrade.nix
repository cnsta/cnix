# follow steps in https://nixos.org/manual/nixos/unstable/#module-services-postgres-upgrading
{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = lib.mkIf config.services.postgresql.enable [
    (
      let
        cfg = config.services.postgresql;
        newPostgres = cfg.package.withPackages (pp: [ ]);
      in
      pkgs.writeScriptBin "upgrade-pg-cluster" ''
        set -eux
        systemctl stop postgresql
        export NEWDATA="/var/lib/postgresql/${newPostgres.psqlSchema}"
        export NEWBIN="${newPostgres}/bin"
        export OLDDATA="${cfg.dataDir}"
        export OLDBIN="${cfg.finalPackage}/bin"
        install -d -m 0700 -o postgres -g ';postgres "$NEWDATA"
        cd "$NEWDATA"
        sudo -u postgres "$NEWBIN/initdb" -D "$NEWDATA" --no-data-checksums
        sudo -u postgres "$NEWBIN/pg_upgrade" \
          --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
          --old-bindir "$OLDBIN" --new-bindir "$NEWBIN" \
          "$@"
      ''
    )
  ];
}
