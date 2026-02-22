{
  config,
  lib,
  self,
  clib,
  ...
}:
let
  unit = "homepage";
  cfg = config.server.services.${unit};
  srv = config.server;
in
{
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
        environmentFiles = config.age.secrets.homepageEnvironment.path;

        settings = {
          color = "stone";
          theme = "dark";
          headerStyle = "clean";
          statusStyle = "dot";
          hideVersion = true;
          useEqualHeights = true;

          layout = [
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

        services =
          let
            homepageCategories = [
              "Arr"
              "Media"
              "Downloads"
              "Services"
            ];
            allServices = srv.services;

            getDomain = s: clib.server.mkHostDomain config s;

            homepageServicesFor =
              category:
              lib.filterAttrs (
                name: value: name != unit && value ? homepage && value.homepage.category == category
              ) allServices;
          in
          lib.lists.forEach homepageCategories (cat: {
            "${cat}" =
              lib.lists.forEach (lib.attrsets.mapAttrsToList (name: _value: name) (homepageServicesFor cat))
                (
                  x:
                  let
                    service = allServices.${x};
                    domain = getDomain service;
                  in
                  {
                    "${service.homepage.name}" = {
                      icon = service.homepage.icon;
                      description = service.homepage.description;
                      href = "https://${service.subdomain}.${domain}${service.homepage.path or ""}";
                      siteMonitor = "https://${service.subdomain}.${domain}${x.homepage.path or ""}";
                    };
                  }
                );
          });
      };
    };
  };
}
