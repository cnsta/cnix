{
  config,
  lib,
  ...
}:
let
  unit = "jellyseerr";
  cfg = config.server.services.${unit};
in
{
  config = lib.mkIf cfg.enable {
    services.${unit} = {
      enable = true;
      port = cfg.port;
    };
  };
}
