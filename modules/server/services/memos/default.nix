{
  config,
  lib,
  ...
}:
let
  unit = "memos";
  cfg = config.server.services.${unit};
in
{
  config = lib.mkIf cfg.enable {
    services = {
      ${unit} = {
        enable = true;
        user = "memos";
        group = "memos";
      };
    };
  };
}
