{
  config,
  lib,
  ...
}: let
  unit = "radarr";
  srv = config.server;
  cfg = config.server.services.${unit};
in {
  config = lib.mkIf cfg.enable {
    services.${unit} = {
      enable = true;
      user = srv.user;
      group = srv.group;
    };
  };
}
