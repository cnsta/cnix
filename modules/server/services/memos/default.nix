{
  config,
  lib,
  options,
  ...
}: let
  unit = "memos";
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf cfg.enable {
    services = {
      ${unit} = {
        enable = true;
        # The option's default is one attrset; merge onto it, don't replace it.
        settings = options.services.memos.settings.default // {MEMOS_PORT = toString cfg.port;};
      };
    };
  };
}
