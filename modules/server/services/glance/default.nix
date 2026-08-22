{
  config,
  lib,
  self,
  clib,
  ...
}: let
  unit = "glance";
  cfg = config.cnix.server.services.${unit};
  srv = config.cnix.server;

  helpers = import ./helpers.nix {inherit config lib clib;};

  w = import ./widgets {
    inherit config lib clib srv unit helpers;
  };
in {
  config = lib.mkIf cfg.enable {
    age.secrets.glanceEnvironment = {
      file = "${self}/secrets/glanceEnvironment.age";
    };

    services.glance = {
      enable = true;
      openFirewall = false;

      environmentFile = config.age.secrets.glanceEnvironment.path;

      settings = {
        server = {
          host = "127.0.0.1";
          port = cfg.port;
          proxied = true;
        };

        branding = {
          app-name = "cnix";
          logo-text = "c";
          hide-footer = true;
        };

        theme = {
          background-color = "240 13 14";
          primary-color = "51 33 68";
          negative-color = "358 100 68";
          contrast-multiplier = 1.2;
          disable-picker = true;
        };

        pages = [
          {
            name = "Home";
            width = "default";
            "hide-desktop-navigation" = true;

            columns = [
              {
                size = "full";
                widgets =
                  w.serverStats
                  ++ w.monitors
                  ++ w.containers;
              }
              {
                size = "small";
                widgets =
                  w.wan
                  ++ w.speedtest
                  ++ w.gluetun
                  ++ w.dns
                  ++ w.releases;
              }
            ];
          }
        ];
      };
    };

    systemd.services.glance = lib.mkMerge [
      {serviceConfig.RestartSec = 5;}
      (lib.mkIf (w.containers != []) {
        after = ["podman.socket"];
        wants = ["podman.socket"];
        serviceConfig.SupplementaryGroups = ["podman"];
      })
    ];
  };
}
