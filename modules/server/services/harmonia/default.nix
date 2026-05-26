{
  config,
  lib,
  self,
  ...
}:
let
  unit = "harmonia";
  cfg = config.cnix.server.services.${unit};
in
{
  config = lib.mkIf cfg.enable {
    age.secrets.harmoniaSignKey = {
      file = "${self}/secrets/harmoniaSignKey.age";
      mode = "0600";
    };

    services.harmonia = {
      cache = {
        enable = true;
        signKeyPaths = [ config.age.secrets.harmoniaSignKey.path ];
        settings.bind = "127.0.0.1:${toString cfg.port}";
      };
    };
  };
}
