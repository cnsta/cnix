{
  config,
  lib,
  pkgs,
  clib,
  ...
}:
let
  unit = "hydra";
  cfg = config.cnix.server.services.${unit};
  domain = clib.server.mkFullDomain config cfg;

  mkBuildMachine =
    {
      uri ? null,
      systems ? null,
      sshKey ? null,
      maxJobs ? 1,
      speedFactor ? 1,
      supportedFeatures ? null,
      mandatoryFeatures ? null,
      publicHostKey ? null,
    }:
    let
      field =
        x:
        if (x == null || x == [ ] || x == "") then
          "-"
        else if (builtins.isInt x) then
          (toString x)
        else if (builtins.isList x) then
          (builtins.concatStringsSep "," x)
        else
          x;
    in
    ''
      ${field uri} ${field systems} ${field sshKey} ${field maxJobs} ${field speedFactor} ${field supportedFeatures} ${field mandatoryFeatures} ${field publicHostKey}
    '';

  mkBuildMachines =
    machines: builtins.toFile "machines" (lib.concatStringsSep "\n" (map mkBuildMachine machines));
in
{
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

    systemd.services.hydra-evaluator.environment.GC_DONT_GC = "true";
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    systemd.services.hydra-evaluator.serviceConfig = {
      MemoryHigh = "8G";
      MemoryMax = "12G";
      CPUWeight = 30;
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
      buildMachinesFiles = [
        (mkBuildMachines [
          {
            uri = "localhost";
            systems = [
              "x86_64-linux"
              "aarch64-linux"
            ];
            maxJobs = 8;
            supportedFeatures = [
              "kvm"
              "big-parallel"
              "nixos-test"
              "benchmark"
            ];
          }
        ])
      ];
      extraConfig = ''
        max_unsupported_time = 30
        allow_import_from_derivation = true
        max_concurrent_evals = 1
      '';
      extraEnv = {
        HYDRA_DISALLOW_UNFREE = "0";
      };
    };
  };
}
