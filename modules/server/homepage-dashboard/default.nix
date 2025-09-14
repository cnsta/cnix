{
  config,
  lib,
  ...
}:
let
  unit = "homepage-dashboard";
  cfg = config.server.homepage-dashboard;
  srv = config.server;
in
{
  options.server.homepage-dashboard = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    misc = lib.mkOption {
      default = [ ];
      type = lib.types.listOf (
        lib.types.attrsOf (
          lib.types.submodule {
            options = {
              description = lib.mkOption {
                type = lib.types.str;
              };
              href = lib.mkOption {
                type = lib.types.str;
              };
              siteMonitor = lib.mkOption {
                type = lib.types.str;
              };
              icon = lib.mkOption {
                type = lib.types.str;
              };
            };
          }
        )
      );
    };
  };
  config = lib.mkIf cfg.enable {
    services.glances.enable = true;
    services.${unit} = {
      enable = true;
      allowedHosts = srv.domain;
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
          datetime = {
            text_size = "x1";
            format = {
              hour12 = false;
              timeStyle = "short";
              dateStyle = "long";
            };
          };
        }
        {
          resources = {
            label = "";
            memory = true;
            disk = [ "/" ];
          };
        }
      ];

      services =
        let
          homepageCategories = [
            "Arr"
            "Media"
            "Downloads"
            "Services"
            "Smart Home"
          ];
          hl = config.server;
          mergedServices = hl // hl.podman;
          homepageServices =
            x:
            (lib.attrsets.filterAttrs (
              name: value: value ? homepage && value.homepage.category == x
            ) mergedServices);
        in
        lib.lists.forEach homepageCategories (cat: {
          "${cat}" =
            lib.lists.forEach
              (lib.attrsets.mapAttrsToList (name: value: {
                inherit name;
                url = value.url;
                homepage = value.homepage;
              }) (homepageServices "${cat}"))
              (x: {
                "${x.homepage.name}" = {
                  icon = x.homepage.icon;
                  description = x.homepage.description;
                  href = "https://${x.url}${x.homepage.path or ""}";
                  siteMonitor = "https://${x.url}${x.homepage.path or ""}";
                };
              });
        })
        ++ [ { Misc = cfg.misc; } ]
        ++ [
          {
            Glances =
              let
                port = toString config.services.glances.port;
              in
              [
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
    services.caddy.virtualHosts."${srv.domain}" = {
      useACMEHost = srv.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.${unit}.listenPort}
      '';
    };
  };
}
