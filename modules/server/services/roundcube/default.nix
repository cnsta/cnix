{
  config,
  lib,
  clib,
  pkgs,
  ...
}:
let
  unit = "roundcube";
  cfg = config.server.services.${unit};
  domain = clib.server.mkFullDomain config cfg;
in
{
  config = lib.mkIf cfg.enable {
    server.infra = {
      fail2ban.jails.${unit} = {
        serviceName = "${unit}";
        failRegex = ".*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>";
      };
      postgresql.databases = [
        { database = unit; }
      ];
    };

    services = {
      roundcube = {
        enable = true;
        hostName = domain;
        configureNginx = true;

        database = {
          host = "localhost";
          dbname = "roundcube";
          username = "roundcube";
        };

        maxAttachmentSize = 50;

        plugins = [
          "managesieve"
          "archive"
          "zipdownload"
        ];

        dicts = with pkgs.aspellDicts; [
          en
          sv
        ];

        extraConfig = ''
          $config['imap_host'] = '127.0.0.1';
          $config['imap_port'] = 10144;
          $config['smtp_host'] = '127.0.0.1';
          $config['smtp_port'] = 10588;

          $config['managesieve_host'] = '127.0.0.1';
          $config['managesieve_port'] = 4190;

          $config['product_name'] = 'cnixpost';
          $config['support_url'] = ''';

          $config['draft_autosave'] = 60;
          $config['refresh_interval'] = 60;

          $config['mime_types'] = '${pkgs.mailcap}/etc/mime.types';
        '';
      };

      nginx.virtualHosts.${domain} = {
        listen = [
          {
            addr = "127.0.0.1";
            port = cfg.port;
          }
        ];
        forceSSL = false;
        enableACME = lib.mkForce false;
      };
    };
  };
}
