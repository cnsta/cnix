{
  config,
  lib,
  ...
}:
let
  unit = "seerr";
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
