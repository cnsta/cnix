{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.cnix.settings.nix;

  dropNull = lib.filterAttrs (_: v: v != null);
in
{
  options = {
    cnix.settings.nix = {
      enable = mkEnableOption ''
        Resource limits for nix-daemon.

        Builds (including those run by nixos-rebuild and Hydra) execute as
        children of nix-daemon, so cgroup limits set here apply to the whole
        build workload. CPUWeight in particular lets builds yield to
        interactive apps under load while still using the full machine when
        it is otherwise idle.
      '';

      cpuWeight = mkOption {
        type = types.nullOr types.int;
        default = 50;
        description = ''
          Relative CPU share under contention (1–10000, default scheduler
          weight is 100). Lower = builds give way to other services/apps.
          Set null to leave unmanaged.
        '';
      };

      ioWeight = mkOption {
        type = types.nullOr types.int;
        default = 50;
        description = "Relative IO share under contention (1–10000). null to leave unmanaged.";
      };

      cpuQuota = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "2400%";
        description = ''
          Hard CPU cap as a percentage where 100% is one thread
          (e.g. "2400%" = 24 threads). null for no hard cap.
          Mutually redundant with allowedCPUs, prefer one.
        '';
      };

      allowedCPUs = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "0-23";
        description = ''
          Pin all builds to this cpuset, physically reserving the rest for
          other work. null to not pin. Use this OR cpuQuota.
        '';
      };

      memoryHigh = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "32G";
        description = "Soft memory limit. Past it the cgroup is throttled and reclaimed. null for none.";
      };

      memoryMax = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "40G";
        description = "Hard memory ceiling. A runaway build is OOM-killed here. Keep above memoryHigh. null for none.";
      };

      manageOOM = mkOption {
        type = types.bool;
        default = true;
        description = "Let systemd-oomd kill builds first under memory pressure (ManagedOOMMemoryPressure=kill).";
      };

      maxJobs = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 4;
        description = "nix.settings.max-jobs, number of derivations built in parallel. null to leave default.";
      };

      cores = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 6;
        description = "nix.settings.cores, threads per build. null to leave default.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nix-daemon.serviceConfig = dropNull {
      CPUWeight = cfg.cpuWeight;
      IOWeight = cfg.ioWeight;
      CPUQuota = cfg.cpuQuota;
      AllowedCPUs = cfg.allowedCPUs;
      MemoryHigh = cfg.memoryHigh;
      MemoryMax = cfg.memoryMax;
      ManagedOOMMemoryPressure = if cfg.manageOOM then "kill" else null;
    };

    nix.settings = dropNull {
      max-jobs = cfg.maxJobs;
      cores = cfg.cores;
    };
  };
}
