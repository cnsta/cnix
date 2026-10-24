{
  lib,
  config,
  ...
}: let
  unit = "cron";
  cfg = config.cnix.server.infra.${unit};

  exec = script:
    if builtins.isString script
    then lib.getExe config.cnix.scripts.${script}.package
    else if lib.isDerivation script
    then lib.getExe script
    else toString script;
in {
  options.cnix.server.infra.${unit}.jobs = lib.mkOption {
    default = {};
    description = "Scheduled jobs, each run as root by a `cron-<name>` systemd timer.";
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        script = lib.mkOption {
          type = with lib.types;
            either (enum (builtins.attrNames config.cnix.scripts)) (either package path);
          example = "update-images";
          description = ''
            A `cnix.scripts` name (scripts/bin/<name>.sh), or a package/path to
            run instead. Its own `cnix.scripts.<name>.enable` is not required.
          '';
        };
        schedule = lib.mkOption {
          type = lib.types.str;
          example = "Mon *-*-* 04:00";
          description = "When to run, as a systemd OnCalendar expression.";
        };
      };
    });
  };

  config = {
    systemd.services = lib.mapAttrs' (name: job:
      lib.nameValuePair "cron-${name}" {
        description = "cron job ${name}";
        restartIfChanged = false;
        serviceConfig = {
          Type = "oneshot";
          ExecStart = exec job.script;
        };
      })
    cfg.jobs;

    systemd.timers = lib.mapAttrs' (name: job:
      lib.nameValuePair "cron-${name}" {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = job.schedule;
          Persistent = true;
          RandomizedDelaySec = "5m";
        };
      })
    cfg.jobs;
  };
}
