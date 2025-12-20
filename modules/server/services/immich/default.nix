{
  config,
  lib,
  ...
}:
let
  unit = "immich";
  cfg = config.server.services.${unit};
in
{
  config = lib.mkIf cfg.enable {
    services.${unit} = {
      enable = true;
      database = {
        enableVectors = false;
      };
    };
  };
}
