{
  config,
  lib,
  ...
}:
let
  unit = "n8n";
  cfg = config.server.services.${unit};
in
{
  config = lib.mkIf cfg.enable {
    services = {
      n8n = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
