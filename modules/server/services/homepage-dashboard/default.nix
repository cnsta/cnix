{
  config,
  lib,
  self,
  clib,
  ...
}: let
  unit = "homepage-dashboard";
  cfg = config.server.services.${unit};
  srv = config.server;
in {
  config = lib.mkIf cfg.enable {
    age.secrets = {
      homepageEnvironment = {
        file = "${self}/secrets/homepageEnvironment.age";
      };
    };

    services = {
      glances.enable = true;

      ${unit} = {
        enable = true;
        environmentFile = config.age.secrets.homepageEnvironment.path;

        settings = {
          layout = [
            {
              Glances = {
                header = false;
                style = "row";
                columns = 4;
              };
            }
            {
              Arr = {
                header = true;
                style = "column";
              };
            }
            {
              Downloads = {
                header = true;
                style = "column";
              };
            }
            {
              Media = {
                header = true;
                style = "column";
              };
            }
            {
              Services = {
                header = true;
                style = "column";
              };
            }
          ];

          headerStyle = "clean";
          statusStyle = "dot";
          hideVersion = "true";
        };

        widgets = [
          {
            openmeteo = {
              label = "Kalmar";
              timezone = "Europe/Stockholm";
              units = "metric";
              cache = 5;
              latitude = 56.707262;
              longitude = 16.324541;
            };
          }
          {
            resources = {
              label = "SYSTEM";
              memory = true;
              cpu = true;
              uptime = false;
            };
          }
        ];

        services = let
          homepageCategories = [
            "Arr"
            "Media"
            "Downloads"
            "Services"
          ];
          allServices = srv.services;

          getDomain = s: clib.server.mkHostDomain config s;

          homepageServicesFor = category:
            lib.filterAttrs
            (
              name: value:
                name
                != unit
                && value ? homepage
                && value.homepage.category == category
            )
            allServices;
        in
          lib.lists.forEach homepageCategories (cat: {
            "${cat}" =
              lib.lists.forEach
              (lib.attrsets.mapAttrsToList (name: _value: name) (homepageServicesFor cat))
              (x: let
                service = allServices.${x};
                domain = getDomain service;
              in {
                "${service.homepage.name}" = {
                  icon = service.homepage.icon;
                  description = service.homepage.description;
                  href = "https://${domain}";
                  siteMonitor = "https://${domain}";
                };
              });
          })
          ++ [
            {
              Glances = let
                port = toString config.services.glances.port;
              in [
                {
                  Info = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "info";
                      chart = false;
                      version = 4;
                    };
                  };
                }
                {
                  "CPU Temp" = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "sensor:Tctl";
                      chart = false;
                      version = 4;
                    };
                  };
                }
                {
                  "GPU Radeon" = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "sensor:junction";
                      chart = false;
                      version = 4;
                    };
                  };
                }
                {
                  "GPU Intel" = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "sensor:pkg";
                      chart = false;
                      version = 4;
                    };
                  };
                }
                {
                  Processes = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "process";
                      chart = false;
                      version = 4;
                    };
                  };
                }
                {
                  Network = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "network:enp6s0";
                      chart = false;
                      version = 4;
                    };
                  };
                }
              ];
            }
          ];
      };
    };
  };
}
