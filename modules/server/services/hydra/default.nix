{
  config,
  lib,
  pkgs,
  clib,
  ...
}: let
  unit = "hydra";
  cfg = config.cnix.server.services.${unit};
  domain = clib.server.mkFullDomain config cfg;
  qr = config.services.hydra.queueRunner;
  buildDevice = config.cnix.settings.nix.buildDevice;
in {
  # Hydra-only fields on the service submodule; values live in modules.nix.
  options.cnix.server.services = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options.io = {
        writeBandwidthMax = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Write bandwidth cap for system-hydra.slice on settings.nix.buildDevice.";
        };
        writeIOPSMax = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Write IOPS cap for system-hydra.slice on settings.nix.buildDevice.";
        };
      };
    });
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.io.writeBandwidthMax != null || cfg.io.writeIOPSMax != null) -> buildDevice != null;
        message = "cnix.server.services.hydra.io needs cnix.settings.nix.buildDevice.";
      }
    ];

    cnix.server.infra.postgresql.databases = [
      {
        database = "hydra";
        identUsers = [
          "hydra"
          "hydra-queue-runner"
          "hydra-www"
          "hydra-ws"
          "root"
        ];
      }
    ];

    nix = {
      package = lib.mkForce pkgs.nix;
      daemonCPUSchedPolicy = "batch";
      daemonIOSchedClass = "idle";
    };

    boot.binfmt.emulatedSystems = ["aarch64-linux"];
    systemd = {
      services.hydra-evaluator = {
        serviceConfig = {
          MemoryHigh = "8G";
          MemoryMax = "12G";
          CPUWeight = 30;
        };
      };
      slices.system-hydra.sliceConfig = lib.filterAttrs (_: v: v != null) {
        IOWriteBandwidthMax = lib.mapNullable (v: "${buildDevice} ${v}") cfg.io.writeBandwidthMax;
        IOWriteIOPSMax = lib.mapNullable (v: "${buildDevice} ${v}") cfg.io.writeIOPSMax;
      };
    };

    services.hydra = {
      enable = true;
      package = pkgs.hydra;
      hydraURL = "https://${domain}";
      notificationSender = "hydra@${config.cnix.settings.site.domains.public}";
      listenHost = "localhost";
      port = cfg.port;
      smtpHost = "localhost";
      useSubstitutes = true;

      queueRunner = {
        rest.port = 8083;
        grpc = {
          address = "[::1]";
          port = 50051;
        };
        settings = {
          maxUnsupportedTimeInS = 30;
        };
      };

      evaluatorSettings.max_concurrent_evals = 1;

      extraConfig = ''
        allow_import_from_derivation = true
      '';
      extraEnv = {
        HYDRA_DISALLOW_UNFREE = "0";
      };
    };

    services.hydra-builder = {
      enable = true;
      queueRunnerAddr = "http://${qr.grpc.address}:${toString qr.grpc.port}";
      settings = {
        systems = [
          "x86_64-linux"
          "i686-linux"
          "aarch64-linux"
        ];
        maxJobs = 4;
        supportedFeatures = [
          "kvm"
          "big-parallel"
          "nixos-test"
          "benchmark"
        ];
      };
    };
  };
}
