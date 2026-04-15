{
  config,
  lib,
  ...
}:
let
  unit = "prowlarr";
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
