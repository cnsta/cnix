{
  config,
  lib,
  clib,
  self,
  ...
}:
let
  unit = "immich";
  cfg = config.server.services.${unit};
  autheliaUrl = clib.server.mkFullDomain config config.server.services.authelia;
in
{
  config = lib.mkIf cfg.enable {
    age.secrets = {
      immichOidc = {
        owner = "immich";
        group = "users";
        file = (self + "/secrets/immichOidcSecret.age");
      };
    };

    server.infra = {
      fail2ban.jails.${unit} = {
        serviceName = "${unit}";
        failRegex = ".*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>";
      };
      postgresql.databases = [
        { database = unit; }
      ];
    };

    services.${unit} = {
      enable = true;
      settings = {
        server.externalDomain = "https://${clib.server.mkFullDomain config cfg}";
        oauth = {
          enabled = true;
          autoLaunch = true;
          autoRegister = true;
          buttonText = "Login";
          clientId = "immich";
          clientSecret._secret = config.age.secrets.immichOidc.path;
          defaultStorageQuota = 0;
          issuerUrl = "https://${autheliaUrl}/.well-known/openid-configuration";
          scope = "openid email profile";
          signingAlgorithm = "RS256";
          profileSigningAlgorithm = "none";
          storageLabelClaim = "preferred_username";
          storageQuotaClaim = "immich_quota";
        };
      };
    };
  };
}
