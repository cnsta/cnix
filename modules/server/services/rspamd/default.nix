{
  config,
  lib,
  ...
}:
let
  unit = "rspamd";
  srv = config.server;
  cfg = config.server.services.${unit};
in
{
  config = lib.mkIf srv.infra.cnixpost.enable {

    age.secrets = {
      mailRedisPw = {
        file = "${self}/secrets/mailRedisPw.age";
        owner = "rspamd";
        group = "rspamd";
        mode = "0440";
      };
      mailRspamdCtrlPw = {
        file = "${self}/secrets/mailRspamdCtrlPw.age";
        owner = "rspamd";
        group = "rspamd";
        mode = "0440";
      };
    };
  };
}
