{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.cnix.server.services.grafana;

  dashboards = {
    node = {
      id = 1860;
      rev = 45;
      hash = "sha256-GExrdAnzBtp1Ul13cvcZRbEM6iOtFrXXjEaY6g6lGYY=";
    };
    traefik = {
      id = 17346;
      rev = 9;
      hash = "sha256-OtMp0nNxIPMvZ6qwg/JFtVTqXE7IN4/u5xlu9ruffak=";
    };
    postgres = {
      id = 9628;
      rev = 8;
      hash = "sha256-UhusNAZbyt7fJV/DhFUK4FKOmnTpG0R15YO2r+nDnMc=";
    };
    unbound = {
      id = 11705;
      rev = 1;
      hash = "sha256-Thje1QgDEb+Qyj3FlwG6syIl/86vs6L7qX53NkctsZk=";
    };
    crowdsec = {
      id = 21419;
      rev = 6;
      hash = "sha256-4fbSv6UwYaEEwV0WH4U63ulu9/diQR72nIrlKPr+77U=";
    };
    smartctl = {
      id = 22604;
      rev = 4;
      hash = "sha256-ah36BdFIcaprUz39hRzuYVzfp3diEBckmalMaOls5kY=";
    };
  };

  fetchDashboard = name: d:
    pkgs.fetchurl {
      name = "grafana-dashboard-${name}.json";
      url = "https://grafana.com/api/dashboards/${toString d.id}/revisions/${toString d.rev}/download";
      inherit (d) hash;
    };

  dir = pkgs.runCommand "grafana-dashboards" {} ''
    mkdir $out
    ${lib.concatStrings (lib.mapAttrsToList (name: d: ''
        sed 's/''${DS_PROMETHEUS}/prometheus/g' ${fetchDashboard name d} > $out/${name}.json
      '')
      dashboards)}
  '';
in {
  config = lib.mkIf (cfg.enable && config.cnix.server.services.prometheus.enable) {
    services.grafana.provision.dashboards.settings.providers = [
      {
        name = "sobotka";
        folder = "sobotka";
        options.path = dir;
        # store paths are read-only, edits in the UI would be lost anyway.
        allowUiUpdates = false;
        disableDeletion = true;
      }
    ];
  };
}
