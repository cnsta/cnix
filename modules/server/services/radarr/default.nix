{
  config,
  lib,
  ...
}:
let
  unit = "radarr";
  srv = config.server;
  cfg = config.server.services.${unit};
  arr = config.server.services.arr;
in
{
  config = lib.mkIf (arr.enable && cfg.enable) {
    services.${unit} = {
      enable = true;
      user = srv.user;
      group = srv.group;
    };
  };
}
