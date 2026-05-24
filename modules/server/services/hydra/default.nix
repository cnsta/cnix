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
    services.hydra = {
      enable = true;
      package = pkgs.hydra;
      hydraURL = "https://${domain}";
      notificationSender = "hydra@${config.cnix.settings.accounts.domains.public}";
      listenHost = "localhost";
      port = cfg.port;
      smtpHost = "localhost";
      useSubstitutes = true;
      extraConfig = ''
        max_unsupported_time = 30
        allow_import_from_derivation = true
      '';
      extraEnv = {
        HYDRA_DISALLOW_UNFREE = "0";
      };
    };
  };
}
