{
  config,
  lib,
  self,
  inputs,
  ...
}: let
  unit = "cnixpost";
  cfg = config.cnix.server.infra.${unit};
  srv = config.cnix.server;

  lldapBaseDn = lib.concatMapStringsSep "," (dc: "dc=" + dc) (lib.splitString "." srv.domain);
in {
  imports = [inputs.cnixpost.nixosModules.default];

  options.cnix.server.infra.${unit} = {
    enable = lib.mkEnableOption "mail server (Postfix + Dovecot + Rspamd + ClamAV)";

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = ''
        Dials forwarded verbatim to the cnixpost module
        (accounts, mtaSts, spam scores, clamav.enable, ...).
        See the cnixpost flake for the full option set.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # the rspamd controller password (bcrypt hash).
    age.secrets.mailRspamdCtrlPw = {
      file = self + "/secrets/mailRspamdCtrlPw.age";
      owner = "rspamd";
      group = "rspamd";
      mode = "0440";
    };

    cnixpost = lib.mkMerge [
      {
        enable = true;
        fqdn = "mail.${srv.domain}";
        primaryDomain = srv.domain;

        rspamdControllerPasswordFile = config.age.secrets.mailRspamdCtrlPw.path;

        lldap = {
          base = lldapBaseDn;
          userDnTemplate = "uid=%n,ou=people,${lldapBaseDn}";
        };

        certsFromTraefik.enable = true;
        traefik = {
          enable = true;
          rspamdUI = {
            enable = true;
            middlewares = ["authelia@file"];
          };
        };
      }
      cfg.settings
    ];
  };
}
