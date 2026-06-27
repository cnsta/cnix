{
  config,
  lib,
  ...
}: let
  unit = "uptime-kuma";
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf cfg.enable {
    services = {
      ${unit} = {
        enable = true;
      };
    };
  };
}
