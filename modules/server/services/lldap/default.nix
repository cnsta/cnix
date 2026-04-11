{
  config,
  lib,
  self,
  ...
}:
with lib;
let
  lldap-user = "lldap";
  lldap-base-dn = lib.strings.concatMapStringsSep "," (dc: "dc=" + dc) (
    lib.splitString "." config.server.domain
  );
  cfg = config.server.services.lldap;
  srv = config.server.infra;
in
{
  config = mkIf cfg.enable {
    age.secrets = {
      lldapAdminPassword = {
        owner = lldap-user;
        group = "users";
        file = "${self}/secrets/lldapAdminPassword.age";
      };
      lldapJwt = {
        owner = lldap-user;
        group = "users";
        file = "${self}/secrets/lldapJwt.age";
      };
      lldapKeySeed = {
        owner = lldap-user;
        group = "users";
        file = "${self}/secrets/lldapKeySeed.age";
      };
    };

    server.infra.postgresql.databases = [
      {
        database = lldap-user;
      }
    ];

    services.lldap = {
      enable = true;
      settings = {
        ldap_base_dn = lldap-base-dn;
        ldap_user_dn = "admin";
        ldap_user_email = "mail@${srv.www.url}";
        ldap_user_pass_file = config.age.secrets.lldapAdminPassword.path;
        jwt_secret_file = config.age.secrets.lldapJwt.path;
        force_ldap_user_pass_reset = "always";
        key_file = "";
        database_url = "postgresql://${lldap-user}@localhost/${lldap-user}?host=/run/postgresql";
      };
      environmentFile = config.age.secrets.lldapKeySeed.path;
    };

    systemd.services.lldap =
      let
        dependencies = [
          "postgresql.service"
        ];
      in
      {
        after = dependencies;
        requires = dependencies;
      };

    users = {
      users.${lldap-user} = {
        group = lldap-user;
        isSystemUser = true;
      };
      groups.${lldap-user} = { };
    };
  };
}
