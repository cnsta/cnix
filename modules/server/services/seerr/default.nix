{
  config,
  lib,
  ...
}: let
  unit = "seerr";
  cfg = config.cnix.server.services.${unit};
  arr = config.cnix.server.services.arr;
in {
  config = lib.mkIf (arr.enable && cfg.enable) {
    services.${unit} = {
      enable = true;
      port = cfg.port;
    };
  };
}
