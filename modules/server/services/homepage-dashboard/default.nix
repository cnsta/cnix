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
          color = "stone";
          theme = "dark";
          headerStyle = "clean";
          statusStyle = "dot";
          hideVersion = true;
          useEqualHeights = true;

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
                  href = "https://${service.subdomain}.${domain}${service.homepage.path or ""}";
                  siteMonitor = "https://${service.subdomain}.${domain}${x.homepage.path or ""}";
                };
              });
          })
          ++ [
            {
              Glances = let
                glancesShared = {
                  type = "glances";
                  url = "http://localhost:${toString config.services.glances.port}";
                  chart = true;
                  version = 4;
                };
              in [
                {
                  Memory = {
                    widget =
                      glancesShared
                      // {
                        metric = "memory";
                        refreshInterval = 2000;
                        pointsLimit = 30;
                      };
                  };
                }
                {
                  "CPU Usage" = {
                    widget =
                      glancesShared
                      // {
                        metric = "cpu";
                        refreshInterval = 2000;
                        pointsLimit = 30;
                      };
                  };
                }

                {
                  "CPU Temp" = {
                    widget =
                      glancesShared
                      // {
                        metric = "sensor:Tctl";
                        refreshInterval = 5000;
                        pointsLimit = 20;
                      };
                  };
                }
                {
                  "GPU Radeon" = {
                    widget =
                      glancesShared
                      // {
                        metric = "sensor:junction";
                      };
                  };
                }
                {
                  "GPU Intel" = {
                    widget =
                      glancesShared
                      // {
                        metric = "sensor:pkg";
                      };
                  };
                }
                {
                  "ZFS Pool" = {
                    widget =
                      glancesShared
                      // {
                        metric = "fs:/mnt/data";
                        refreshInterval = 30000;
                        pointsLimit = 20;
                        diskUnits = "bytes";
                      };
                  };
                }

                {
                  Processes = {
                    widget =
                      glancesShared
                      // {
                        metric = "process";
                      };
                  };
                }
                {
                  Network = {
                    widget =
                      glancesShared
                      // {
                        metric = "network:enp6s0";
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
