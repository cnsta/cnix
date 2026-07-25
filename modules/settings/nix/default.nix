{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.cnix.settings.nix;

  dropUnset = lib.filterAttrs (_: v: v != null && v != []);

  resourceControl = dropUnset {
    CPUWeight = cfg.cpuWeight;
    CPUQuota = cfg.cpuQuota;
    AllowedCPUs = cfg.allowedCPUs;
    IOWeight = cfg.ioWeight;
    IOReadBandwidthMax = cfg.ioReadBandwidthMax;
    IOWriteBandwidthMax = cfg.ioWriteBandwidthMax;
    IOReadIOPSMax = cfg.ioReadIOPSMax;
    IOWriteIOPSMax = cfg.ioWriteIOPSMax;
    MemoryHigh = cfg.memoryHigh;
    MemoryMax = cfg.memoryMax;
    ManagedOOMMemoryPressure =
      if cfg.manageOOM
      then "kill"
      else null;
  };
in {
  options = {
    cnix.settings.nix = {
      enable = mkEnableOption ''
        Resource limits for Nix builds.

        IMPORTANT: nix-daemon.socket uses Accept=yes, so each client
        connection spawns an instance nix-daemon@<id>.service. systemd places
        template instances in system-<template>.slice, meaning builds run in
        system-nix\x2ddaemon.slice and NOT under nix-daemon.service. Limits
        set on nix-daemon.service alone therefore apply to nothing.

        Limits here are applied to the slice (where builds live) and to
        nix-daemon.service (harmless, and covers hosts where the daemon is
        not socket-activated).

        Verify on a given host with:
          systemd-cgls /sys/fs/cgroup/system.slice
          cat '/sys/fs/cgroup/system.slice/system-nix\x2ddaemon.slice/io.max'
      '';

      cpuWeight = mkOption {
        type = types.nullOr types.int;
        default = 50;
        description = ''
          Relative CPU share under contention (1-10000, default 100).
          Lower = builds give way to other services. Only applies when the
          CPU is actually contended; an idle machine still builds at full
          speed. null to leave unmanaged.
        '';
      };

      cpuQuota = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "2400%";
        description = ''
          Hard CPU cap where 100% is one thread ("2400%" = 24 threads).
          Prefer allowedCPUs on NUMA or cache-sensitive hosts. null for no cap.
        '';
      };

      allowedCPUs = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "0-23";
        description = ''
          Pin builds to this cpuset, physically reserving the rest.
          Use this OR cpuQuota, not both. null to not pin.
        '';
      };

      ioWeight = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Relative IO share (1-10000). CAVEAT: io.weight is only honoured by
          the BFQ scheduler or a configured iocost controller. On a host using
          the "none" scheduler (typical for NVMe) with no io.cost.qos set, the
          kernel accepts this value and silently ignores it. Check with:

            cat /sys/block/<dev>/queue/scheduler
            cat /sys/fs/cgroup/io.cost.qos

          Prefer the ioWriteBandwidthMax / ioWriteIOPSMax options below, which
          are enforced by blk-throttle regardless of scheduler. Defaults to
          null precisely because it is a no-op on most hosts.
        '';
      };

      ioReadBandwidthMax = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["/dev/nvme0n1 400M"];
        description = ''
          Hard read bandwidth caps, one "DEVICE RATE" entry per line.
          Device may be a block node or a path on the filesystem in question.
        '';
      };

      ioWriteBandwidthMax = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["/dev/nvme0n1 200M"];
        description = ''
          Hard write bandwidth caps. This is the effective lever for keeping
          builds from saturating a device and stalling everything else on it.
        '';
      };

      ioReadIOPSMax = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["/dev/nvme0n1 40000"];
        description = "Hard read IOPS caps, one \"DEVICE COUNT\" entry per line.";
      };

      ioWriteIOPSMax = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["/dev/nvme0n1 20000"];
        description = ''
          Hard write IOPS caps. Bites harder than a bandwidth cap when the
          workload is many small writes, which is typical of Nix builds and
          Hydra evaluation, and is the worst pattern for DRAM-less SSDs.
        '';
      };

      memoryHigh = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "32G";
        description = ''
          Soft memory limit. Past it the cgroup is throttled and aggressively
          reclaimed; a build sitting between memoryHigh and memoryMax keeps
          the kernel in a reclaim loop, so keep the gap generous. null for none.
        '';
      };

      memoryMax = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "40G";
        description = "Hard ceiling; a runaway build is OOM-killed here. Keep above memoryHigh. null for none.";
      };

      manageOOM = mkOption {
        type = types.bool;
        default = true;
        description = "Let systemd-oomd kill builds first under memory pressure.";
      };

      maxJobs = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 4;
        description = ''
          nix.settings.max-jobs, derivations built in parallel. Note this does
          NOT constrain Hydra, which schedules against its build-machines file;
          cap that separately via its own maxJobs field.
        '';
      };

      cores = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 6;
        description = "nix.settings.cores, threads per build. Total concurrency is roughly maxJobs * cores.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.cpuQuota != null && cfg.allowedCPUs != null);
        message = "cnix.settings.nix: set either cpuQuota or allowedCPUs, not both.";
      }
    ];

    systemd = {
      slices."system-nix\\x2ddaemon".sliceConfig = resourceControl;
      services.nix-daemon.serviceConfig = resourceControl;
    };

    nix.settings = dropUnset {
      max-jobs = cfg.maxJobs;
      cores = cfg.cores;
    };
  };
}
