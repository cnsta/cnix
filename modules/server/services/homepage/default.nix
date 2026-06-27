{
  config,
  lib,
  self,
  clib,
  ...
}: let
  unit = "homepage";
  cfg = config.cnix.server.services.${unit};
  srv = config.cnix.server;

  wanIP = {url}: {
    icon = "sh-mikrotik";
    href = url;
    widget = {
      type = "customapi";
      url = "https://api.ipify.org?format=json";
      method = "GET";
      refreshInterval = 100000;
      mappings = [
        {
          field = "ip";
          format = "text";
        }
      ];
    };
  };
in {
  config = lib.mkIf cfg.enable {
    age.secrets = {
      homepageEnvironment = {
        file = "${self}/secrets/homepageEnvironment.age";
      };
    };

    services = {
      glances = {
        enable = false;
        openFirewall = true;
        extraArgs = [
          "--webserver"
          "--disable-webui"
        ];
      };
      homepage-dashboard = {
        enable = true;
        environmentFiles = [config.age.secrets.homepageEnvironment.path];

        settings = {
          color = "stone";
          theme = "dark";
          headerStyle = "clean";
          statusStyle = "dot";
          hideVersion = true;
          useEqualHeights = true;

          layout = [
            {
              Monitor = {
                header = true;
                style = "row";
              };
            }
            {
              Media = {
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
              Cloud = {
                header = true;
                style = "column";
              };
            }
            {
              Dev = {
                header = true;
                style = "column";
              };
            }
            {
              Automation = {
                header = true;
                style = "column";
              };
            }
            {
              Communication = {
                header = true;
                style = "column";
              };
            }
            {
              Infra = {
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
            search = {
              provider = "custom";
              url = "https://search.cnix.dev/search?q=";
              target = "_blank";
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
            "Monitor"
            "Media"
            "Downloads"
            "Cloud"
            "Dev"
            "Automation"
            "Communication"
            "Infra"
          ];
          allServices = srv.services;

          getDomain = s: clib.server.mkHostDomain config s;

          homepageServicesFor = category:
            lib.filterAttrs (
              name: value:
                name != unit && value.enable && value.homepage.category != "" && value.homepage.category == category
            )
            allServices;

          automatedEntries = cat:
            lib.attrsets.mapAttrsToList (name: service: {
              "${service.homepage.name}" = {
                icon = service.homepage.icon;
                description = service.homepage.description;
                href = "https://${service.subdomain}.${getDomain service}${service.homepage.path or ""}";
                siteMonitor = "https://${service.subdomain}.${getDomain service}${service.homepage.path or ""}";
              };
            }) (homepageServicesFor cat);

          customEntries = {
            Monitor = [
              {"WAN IP" = wanIP {url = "https://192.168.88.1";};}
            ];
            # Add more categories here as needed, e.g.:
            # Media = [ { "Some Service" = { ... }; } ];
          };

          entriesFor = cat: (automatedEntries cat) ++ (customEntries.${cat} or []);
        in
          lib.lists.forEach homepageCategories (cat: {
            "${cat}" = entriesFor cat;
          });
      };
    };
  };
}
