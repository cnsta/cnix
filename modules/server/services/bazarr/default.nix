{
  config,
  lib,
  ...
}: let
  unit = "bazarr";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
  arr = config.cnix.server.services.arr;
in {
  config = lib.mkIf (arr.enable && cfg.enable) {
    services.${unit} = {
      enable = true;
      user = srv.user;
      group = srv.group;
    };
  };
}
