{
  lib,
  srv,
  unit,
  helpers,
  ...
}: let
  inherit (helpers) mkIcon publicUrl;

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

  sitesFor = cat: lib.mapAttrsToList mkSite (servicesIn cat);

  # customSites = {
  #   Infra = [
  #     {
  #       title = "MikroTik";
  #       url = "https://192.168.88.1";
  #       icon = mkIcon "sh-mikrotik";
  #       "alt-status-codes" = [401 403];
  #     }
  #   ];
  # };

  monitors =
    map (cat: {
      type = "monitor";
      title = cat;
      cache = "5m";
      sites = sitesFor cat;
    })
    (lib.filter (c: sitesFor c != []) categories);
in
  lib.optional (monitors != []) {
    type = "split-column";
    "max-columns" = 3;
    widgets = monitors;
  }
