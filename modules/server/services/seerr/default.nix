{
  config,
  lib,
  ...
}: let
  unit = "seerr";
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf cfg.enable {
    services.${unit} = {
      enable = true;
      port = cfg.port;
    };
    systemd.services.${unit}.environment.LOG_LEVEL = "info";
  };
}
