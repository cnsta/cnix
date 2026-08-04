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

  podmanSocket = "/run/podman/podman.sock";

  mkIcon = icon: let
    prefixed = builtins.match "(sh|si|di|mdi)-(.+)" icon;
    parts = lib.splitString "." icon;
    ext = lib.last parts;
    base = lib.concatStringsSep "." (lib.init parts);
  in
    if icon == ""
    then null
    else if lib.hasPrefix "http" icon
    then icon
    else if prefixed != null
    then "${builtins.elemAt prefixed 0}:${builtins.elemAt prefixed 1}"
    else if builtins.length parts > 1
    then "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/${ext}/${base}.${ext}"
    else "di:${icon}";

  # Service -> monitor site
  getDomain = s: clib.server.mkHostDomain config s;
  publicUrl = s: "https://${s.subdomain}.${getDomain s}${s.dashboard.path}";

  visible = lib.filterAttrs (name: s: name != unit && s.enable) srv.services;

  categories = [
    "Infra"
    "Media"
    "Downloads"
    "Cloud"
    "Dev"
    "Communication"
    "Automation"
  ];

  servicesIn = category:
    lib.filterAttrs (
      name: s:
        name != unit && s.enable && s.dashboard.category == category
    )
    srv.services;

  checkUrlFor = s:
    if s.dashboard.checkUrl != ""
    then s.dashboard.checkUrl
    else "http://localhost:${toString s.port}${s.dashboard.checkPath}";

  mkSite = _name: s:
    lib.filterAttrs (_: v: v != null) ({
        title = s.dashboard.name;
        url = publicUrl s;
        icon = mkIcon s.dashboard.icon;
        timeout = "5s";
      }
      // lib.optionalAttrs (s.dashboard.check == "local") {
        "check-url" = checkUrlFor s;
      }
      // lib.optionalAttrs (s.dashboard.altStatusCodes != []) {
        "alt-status-codes" = s.dashboard.altStatusCodes;
      });

  # customSites = {
  #   Infra = [
  #     {
  #       title = "MikroTik";
  #       url = "https://192.168.88.1";
  #       icon = mkIcon "sh-mikrotik";
  #       "alt-status-codes" = [401 403];
  #     }
  #   ];
  # Media = [ { title = "..."; url = "..."; } ];
  # };

  sitesFor = cat: (lib.mapAttrsToList mkSite (servicesIn cat));
  # ++ (customSites.${cat} or []);

  monitors =
    map (cat: {
      type = "monitor";
      title = cat;
      cache = "5m";
      sites = sitesFor cat;
    })
    (lib.filter (c: sitesFor c != []) categories);

  containerised =
    lib.filterAttrs (_: s: s.dashboard.container.name != "") visible;

  mkContainerEntries = _name: s: let
    cname = s.dashboard.container.name;

    parent = {
      "${cname}" =
        lib.filterAttrs (_: v: v != null) {
          name = s.dashboard.name;
          url = publicUrl s;
          icon = mkIcon s.dashboard.icon;
          hide = false;
        }
        // lib.optionalAttrs (s.dashboard.container.children != {}) {
          id = cname;
        };
    };

    children =
      lib.mapAttrs (_: label: {
        name = label;
        parent = cname;
        hide = false;
      })
      s.dashboard.container.children;
  in
    parent // children;

  containers =
    lib.foldl' (a: b: a // b) {}
    (lib.mapAttrsToList mkContainerEntries containerised);

  containersWidget = lib.optional (containers != {}) {
    type = "docker-containers";
    title = "Containers";
    "sock-path" = podmanSocket;
    # only show what we've declared, keeps pod infra containers out of the way.
    "hide-by-default" = true;
    "running-only" = false;
    inherit containers;
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
              # Main column: host stats, then one monitor per category
              {
                size = "full";
                widgets =
                  [
                    {
                      type = "server-stats";
                      servers = [
                        {
                          type = "local";
                          name = config.networking.hostName;
                          "hide-mountpoints-by-default" = true;
                          mountpoints = {
                            "/" = {
                              hide = false;
                              name = "Root";
                            };
                            # "/mnt/media" = { hide = false; name = "Media"; };
                          };
                        }
                      ];
                    }
                  ]
                  ++ [
                    {
                      type = "split-column";
                      "max-columns" = 2;
                      widgets = monitors;
                    }
                  ]
                  ++ containersWidget;
              }

              # Side column: network + DNS + releases
              {
                size = "small";
                widgets = [
                  {
                    type = "custom-api";
                    title = "WAN";
                    "title-url" = "https://192.168.88.1";
                    cache = "15m";
                    url = "https://ipinfo.io/json";
                    template = ''
                      <div class="flex flex-column gap-5 text-center">
                        <div class="color-highlight size-h2">{{ .JSON.String "ip" }}</div>
                        <div class="size-h5 color-paragraph">{{ .JSON.String "city" }}, {{ .JSON.String "country" }}</div>
                        <div class="size-h6 color-subdue">{{ .JSON.String "org" }}</div>
                      </div>
                    '';
                  }
                  {
                    type = "dns-stats";
                    service = "pihole-v6";
                    url = "http://127.0.0.1:${toString srv.services.pihole.port}";
                    password = "\${PIHOLE_PASSWORD}";
                    "hour-format" = "24h";
                  }
                  {
                    type = "releases";
                    cache = "6h";
                    "show-source-icon" = true;
                    "collapse-after" = 5;
                    repositories = [
                      "glanceapp/glance"
                      "traefik/traefik"
                      "authelia/authelia"
                      "jellyfin/jellyfin"
                      "immich-app/immich"
                    ];
                  }
                ];
              }
            ];
          }
        ];
      };
    };

    systemd.services.glance = lib.mkMerge [
      {serviceConfig.RestartSec = 5;}
      (lib.mkIf (containers != {}) {
        after = ["podman.socket"];
        wants = ["podman.socket"];
        serviceConfig.SupplementaryGroups = ["podman"];
      })
    ];
  };
}
