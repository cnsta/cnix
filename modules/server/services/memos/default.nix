{
  config,
  lib,
  ...
}: let
  unit = "memos";
  cfg = config.cnix.server.services.${unit};
in {
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
