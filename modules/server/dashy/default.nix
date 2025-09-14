{ config, lib, ... }:
let
  unit = "dashy";
  cfg = config.server.${unit};
  srv = config.server;

  hl = config.server;
  mergedServices = hl // (hl.podman or { });

  dashyCategories = [
    "Arr"
    "Media"
    "Downloads"
    "Services"
    "Smart Home"
  ];

  getServicesByCategory =
    cat:
    lib.attrsets.filterAttrs (name: value: (value ? category && value.category == cat)) mergedServices;

  mkItems =
    services:
    lib.attrsets.mapAttrsToList (name: value: {
      title = value.name or name;
      description = value.description or "";
      url =
        if value ? href then
          value.href
        else
          (if value ? url then "https://${value.url}${value.path or ""}" else "");
      icon = value.icon or "";
    }) services;
in
{
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };

    misc = lib.mkOption {
      default = [ ];
      type = lib.types.listOf (
        lib.types.attrsOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption { type = lib.types.str; };
              description = lib.mkOption {
                type = lib.types.str;
                default = "";
              };
              href = lib.mkOption { type = lib.types.str; };
              icon = lib.mkOption { type = lib.types.str; };
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
      port = cfg.port or 8081;
      extraOptions = [
        "-p"
        "${toString config.services.${unit}.port}:80"
      ];

      settings = {
        pageInfo = {
          title = "${srv.domain} Homelab";
          description = "Homelab made with NixOS";
          navLinks = [
            {
              title = "GitHub";
              path = "https://github.com/cnsta/cnix";
            }
          ];
        };

        appConfig = {
          theme = "material-dark";
          layout = "auto";
          iconSize = "medium";
          language = "en";
          statusCheck = true;
          hideComponents.hideSettings = false;
        };

        sections =
          (lib.lists.forEach dashyCategories (cat: {
            name = cat;
            icon = "fas fa-box"; # adjust per category
            items = mkItems (getServicesByCategory cat);
          }))
          ++ [
            {
              name = "Misc";
              icon = "fas fa-ellipsis-h";
              items = lib.lists.map (x: {
                title = x.name;
                description = x.description or "";
                url = x.href or "";
                icon = x.icon or "";
              }) cfg.misc;
            }
            {
              name = "Monitoring";
              icon = "fas fa-monitor-heart-rate";
              items = [
                {
                  title = "Glances";
                  url = "http://localhost:${toString config.services.glances.port}";
                  icon = "hl-glances";
                }
              ];
            }
          ];
      };
    };

    services.caddy.virtualHosts."${srv.domain}" = {
      useACMEHost = srv.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.${unit}.port}
      '';
    };
  };
}
