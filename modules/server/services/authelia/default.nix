{
  config,
  lib,
  self,
  ...
}:
let
  unit = "authelia";
  cfg = config.server.services.${unit};
  srv = config.server.infra;
  domain = "${cfg.subdomain}.${config.server.infra.www.url}";
in
{
  config = lib.mkIf cfg.enable {
    age.secrets = {
      autheliaSession = {
        owner = unit;
        group = "users";
        file = "${self}/secrets/autheliaSession.age";
      };
      autheliaStorage = {
        owner = unit;
        group = "users";
        file = "${self}/secrets/autheliaStorage.age";
      };
      autheliaJwt = {
        owner = unit;
        group = "users";
        file = "${self}/secrets/autheliaJwt.age";
      };
      # autheliaSmtp = {
      #   owner = unit;
      #   group = "users";
      #   file = "${self}/secrets/fastmail.age";
      # };
      autheliaPostgres = {
        owner = unit;
        group = "users";
        file = "${self}/secrets/autheliaPostgres.age";
      };
      autheliaOidcHmac = {
        owner = unit;
        group = "users";
        file = "${self}/secrets/autheliaOidcHmac.age";
      };
      autheliaOidcIssuerKey = {
        owner = unit;
        group = "users";
        file = "${self}/secrets/autheliaOidcIssuerPem.age";
      };
      lldapAdminPasswordAuthelia = {
        owner = unit;
        group = "users";
        file = "${self}/secrets/lldapAdminPassword.age";
      };
    };

    server.infra = {
      fail2ban.jails.${unit} = {
        serviceName = "${unit}";
        failRegex = ''^.*?Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$'';
      };
      postgresql.databases = [
        {
          database = unit;
          extraUsers = [ unit ];
        }
      ];
    };

    services = {
      # cloudflared = {
      #   enable = true;
      #   tunnels.${cfg.cloudflared.tunnelId} = {
      #     credentialsFile = cfg.cloudflared.credentialsFile;
      #     default = "http_status:404";
      #     ingress."${domain}".service = "http://localhost:${toString cfg.port}";
      #   };
      # };

      authelia.instances.main = {
        enable = true;
        user = unit;
        group = unit;
        secrets = {
          jwtSecretFile = config.age.secrets.autheliaJwt.path;
          oidcHmacSecretFile = config.age.secrets.autheliaOidcHmac.path;
          oidcIssuerPrivateKeyFile = config.age.secrets.autheliaOidcIssuerKey.path;
          sessionSecretFile = config.age.secrets.autheliaSession.path;
          storageEncryptionKeyFile = config.age.secrets.autheliaStorage.path;
        };
        settings = {
          theme = "auto";
          server = {
            address = "tcp://:${toString cfg.port}";
            # asset_path = assets-no-symlinks;
          };
          session = {
            cookies = [
              ({
                domain = srv.www.url;
                authelia_url = "https://${domain}";
                default_redirection_url = "https://${srv.www.url}/reload";
              })
            ];
            redis.host = "/run/redis-authelia-main/redis.sock";
          };
          access_control = {
            default_policy = "deny";
            rules = lib.mkAfter [
              {
                domain = "*.${srv.www.url}";
                policy = "one_factor";
              }
            ];
          };
          password_policy.standard = {
            enabled = true;
            min_length = 12;
          };
          webauthn = {
            enable_passkey_login = true;
            experimental_enable_passkey_uv_two_factors = true;
            experimental_enable_passkey_upgrade = true;
            selection_criteria = {
              attachment = "platform";
              discoverability = "required";
              user_verification = "preferred";
            };
            attestation_conveyance_preference = "direct";
            filtering.prohibit_backup_eligibility = false;
            metadata = {
              enabled = true;
              validate_trust_anchor = true;
              validate_entry = false;
              validate_status = true;
              validate_entry_permit_zero_aaguid = false;
            };
          };
          authentication_backend.ldap = {
            address = "ldap://localhost:${toString config.services.lldap.settings.ldap_port}";
            base_dn = config.services.lldap.settings.ldap_base_dn;
            users_filter = "(&({username_attribute}={input})(objectClass=person))";
            groups_filter = "(member={dn})";
            user = "uid=${config.services.lldap.settings.ldap_user_dn},ou=people,${config.services.lldap.settings.ldap_base_dn}";
          };
          storage.postgres = {
            address = "unix:///run/postgresql";
            database = unit;
            username = unit;
          };
          # notifier.smtp = {
          #   address = "${config.site.email.server}:${toString config.site.email.port}";
          #   username = config.site.email.username;
          #   sender = "${config.site.domain} — Authentication <services.authentication@${config.site.domain}>";
          #   subject = "{title}";
          # };
          log.level = "debug";
          identity_providers.oidc = {
            cors = {
              endpoints = [
                "authorization"
                "token"
                "revocation"
                "introspection"
                "userinfo"
              ];
              allowed_origins_from_client_redirect_uris = true;
            };
            authorization_policies.default = {
              default_policy = "one_factor";
              rules = [
                {
                  policy = "deny";
                  subject = "group:lldap_strict_readonly";
                }
              ];
            };
          };
          # Necessary for Caddy integration
          # See https://www.authelia.com/integration/proxies/caddy/#implementation
          # server.endpoints.authz.forward-auth.implementation = "ForwardAuth";
        };
        environmentVariables = {
          AUTHELIA_STORAGE_POSTGRES_PASSWORD_FILE = config.age.secrets.autheliaPostgres.path;
          AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE =
            config.age.secrets.lldapAdminPasswordAuthelia.path;
          # AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.age.secrets.autheliaSmtp.path;
        };
      };

      redis.servers.authelia-main = {
        enable = true;
        user = unit;
        port = 0;
        unixSocket = "/run/redis-authelia-main/redis.sock";
        unixSocketPerm = 600;
      };
    };

    systemd.services."authelia-main" =
      let
        dependencies = [
          "postgresql.service"
          "lldap.service"
        ];
      in
      {
        after = dependencies;
        requires = dependencies;
      };

    users = {
      users.${unit} = {
        group = unit;
        isSystemUser = true;
      };
      groups.${unit} = { };
    };
  };
}
