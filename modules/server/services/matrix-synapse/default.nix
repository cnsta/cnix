{
  config,
  lib,
  clib,
  pkgs,
  self,
  ...
}:
let
  unit = "matrix-synapse";
  cfg = config.server.services.${unit};
  domain = clib.server.mkFullDomain config cfg;
in
{
  config = lib.mkIf cfg.enable {
    age.secrets = {
      matrixShared.file = "${self}/secrets/matrixShared.age";
    };

    environment.systemPackages = [ pkgs.matrix-synapse ];
    server.infra.postgresql.databases = [
      {
        database = "matrix-synapse";
      }
    ];

    services = {
      matrix-synapse = {
        enable = true;

        settings = {
          server_name = domain;
          public_baseurl = "https://${domain}";
          registration_shared_secret = config.age.secrets.matrixShared.path;
          database_type = "psycopg2";
          database_args = {
            database = "matrix-synapse";
          };

          enable_authenticated_media = false;
          allow_guest_access = false;
          enable_registration = false;

          listeners = [
            {
              bind_addresses = [ "127.0.0.1" ];
              port = 11338;
              tls = false;
              x_forwarded = true;
              resources = [
                {
                  names = [ "federation" ];
                  compress = false;
                }
              ];
            }

            {
              bind_addresses = [ "127.0.0.1" ];
              port = 11339;
              tls = false;
              x_forwarded = true;
              resources = [
                {
                  names = [ "client" ];
                  compress = false;
                }
              ];
            }
          ];
        };
      };
    };
  };
}
