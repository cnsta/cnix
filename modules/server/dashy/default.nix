{
  pkgs,
  config,
  lib,
  ...
}: let
  unit = "dashy";
  cfg = config.server.${unit};
  srv = config.server;

  hl = config.server;
  mergedServices = hl // (hl.podman or {});

  dashyCategories = [
    "Arr"
    "Media"
    "Downloads"
    "Services"
    "Smart Home"
  ];

  getServicesByCategory = cat:
    lib.attrsets.filterAttrs (name: value: (value ? category && value.category == cat)) mergedServices;

  # This function was missing its 'services' argument at the end of the call.
  mkItems = services:
    lib.attrsets.mapAttrsToList (name: value: {
      title = value.name or name;
      description = value.description or "";
      url =
        if value ? href
        then value.href
        else if value ? url
        then "https://${value.url}${value.path or ""}"
        else "";
      icon = value.icon or "";
    })
    services; # <-- FIX: Added the 'services' argument here.

  esc = s: lib.replaceStrings ["\""] ["\\\""] (toString s);

  renderSection = {
    name,
    icon,
    items,
  }: ''
    - name: "${esc name}"
      icon: "${esc icon}"
      items:
      ${lib.concatStringsSep "\n" (
      lib.lists.map (item: ''
        - title: "${esc item.title}"
          description: "${esc item.description}"
          url: "${esc item.url}"
          icon: "${esc item.icon}"
      '')
      items
    )}
  '';
in {
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
      internal = true;
      description = "Path to the generated Dashy config file.";
    };

    misc = lib.mkOption {
      default = [];
      type = lib.types.listOf (
        lib.types.attrsOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {type = lib.types.str;};
              description = lib.mkOption {
                type = lib.types.str;
                default = "";
              };
              href = lib.mkOption {type = lib.types.str;};
              icon = lib.mkOption {type = lib.types.str;};
            };
          }
        )
      );
    };
  };

  config = lib.mkIf cfg.enable {
    services.glances.enable = true;

    server.dashy.configFile = pkgs.writeText "conf.yml" ''
      pageInfo:
        title: "${esc "${srv.domain} Homelab"}"
        description: "${esc "Homelab made with NixOS"}"
        navLinks:
          - title: "GitHub"
            path: "https://github.com/cnsta/cnix"

      appConfig:
        theme: "material-dark"
        layout: "auto"
        iconSize: "medium"
        language: "en"
        statusCheck: true
        hideComponents:
          hideSettings: false

      sections:
      ${lib.concatStringsSep "\n" (
        lib.lists.map (
          cat:
            renderSection {
              name = cat;
              icon = "fas fa-box";
              items = mkItems (getServicesByCategory cat);
            }
        )
        dashyCategories
      )}
      ${renderSection {
        name = "Misc";
        icon = "fas fa-ellipsis-h";
        items =
          lib.lists.map (x: {
            title = x.name;
            description = x.description or "";
            url = x.href or "";
            icon = x.icon or "";
          })
          cfg.misc;
      }}
      ${renderSection {
        name = "Monitoring";
        icon = "fas fa-monitor-heart-rate";
        items = [
          {
            title = "Glances";
            description = "System Monitoring";
            url = "http://localhost:${toString config.services.glances.port}";
            icon = "hl-glances";
          }
        ];
      }}
    '';
  };
}
