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
in {
  config = lib.mkIf cfg.enable {
    cnix.server.infra.postgresql.databases = [
      {
        database = "hydra";
        identUsers = [
          "hydra"
          "hydra-queue-runner"
          "hydra-www"
          "root"
        ];
      }
    ];

    boot.binfmt.emulatedSystems = ["aarch64-linux"];
    systemd = {
      services.hydra-evaluator = {
        environment.GC_DONT_GC = "true";
        serviceConfig = {
          MemoryHigh = "8G";
          MemoryMax = "12G";
          CPUWeight = 30;
        };
      };
      slices.system-hydra.sliceConfig = {
        IOWriteBandwidthMax = "/dev/nvme0n1 100M";
        IOWriteIOPSMax = "/dev/nvme0n1 10000";
      };
    };

    services.hydra = {
      enable = true;
      package = pkgs.hydra;
      hydraURL = "https://${domain}";
      notificationSender = "hydra@${config.cnix.settings.accounts.domains.public}";
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

      extraConfig = ''
        allow_import_from_derivation = true
        max_concurrent_evals = 1
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
        maxJobs = 3;
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
