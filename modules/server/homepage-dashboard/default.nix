{
  config,
  lib,
  ...
}: let
  service = "homepage-dashboard";
  cfg = config.server.homepage-dashboard;
  server = config.server;
in {
  options.server.homepage-dashboard = {
    enable = lib.mkEnableOption {
      description = "Enable ${service}";
    };
    misc = lib.mkOption {
      default = [];
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
    services.${service} = {
      enable = true;
      environmentFile = config.age.secrets.homepage-env.path;
      customCSS = ''
        body, html {
          font-family: vcr-mono, Inter, sans-serif !important;
        }
        .font-medium {
          font-weight: 700 !important;
        }
        .font-light {
          font-weight: 500 !important;
        }
        .font-thin {
          font-weight: 400 !important;
        }
        #information-widgets {
          padding-left: 1.5rem;
          padding-right: 1.5rem;
        }
        div#footer {
          display: none;
        }
        .services-group.basis-full.flex-1.px-1.-my-1 {
          padding-bottom: 3rem;
        };
      '';
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
      services = let
        homepageCategories = [
          "Arr"
          "Media"
          "Downloads"
          "Services"
          "Smart Home"
        ];
        hl = config.server;
        homepageServices = x: (lib.attrsets.filterAttrs (
            name: value: value ? homepage && value.homepage.category == x
          )
          server);
      in
        lib.lists.forEach homepageCategories (cat: {
          "${cat}" =
            lib.lists.forEach (lib.attrsets.mapAttrsToList (name: value: name) (homepageServices "${cat}"))
            (x: {
              "${hl.${x}.homepage.name}" = {
                icon = hl.${x}.homepage.icon;
                description = hl.${x}.homepage.description;
                href = "https://${hl.${x}.url}";
                siteMonitor = "https://${hl.${x}.url}";
              };
            });
        })
        ++ [{Misc = cfg.misc;}]
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
                    metric = "sensor:Composite";
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
    services.caddy.virtualHosts."${server.domain}" = {
      useACMEHost = server.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.${service}.listenPort}
      '';
    };
  };
}
