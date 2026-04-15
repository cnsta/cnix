{
  config,
  lib,
  ...
}:
let
  unit = "flaresolverr";
  cfg = config.server.services.${unit};
  arr = config.server.services.arr;
in
{
  config = lib.mkIf (arr.enable && cfg.enable) {
    services = {
      ${unit} = {
        enable = true;
      };
    };
  };
}
