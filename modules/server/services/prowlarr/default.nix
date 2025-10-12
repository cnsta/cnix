{
  config,
  lib,
  ...
}: let
  unit = "prowlarr";
  cfg = config.server.services.${unit};
in {
  config = lib.mkIf cfg.enable {
    services = {
      ${unit} = {
        enable = true;
      };
    };
  };
}
