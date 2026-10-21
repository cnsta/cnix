{lib}: let
  ds = {
    type = "prometheus";
    uid = "prometheus";
  };

  steps = map (s: {
    value = builtins.elemAt s 0;
    color = builtins.elemAt s 1;
  });
  okBad = steps [[null "green"] [1 "red"]];

  query = {
    expr,
    legend ? "",
    instant ? false,
    format ? "time_series",
  }: {
    datasource = ds;
    refId = "A";
    inherit expr instant format;
    legendFormat = legend;
  };

  base = type: {
    title,
    w,
    h,
    targets,
    unit ? "none",
    thresholds ? steps [[null "green"]],
    mappings ? [],
    options ? {},
    min ? null,
    max ? null,
    decimals ? null,
    extra ? {},
  }:
    {
      inherit type title targets options;
      size = {inherit w h;};
      datasource = ds;
      fieldConfig = {
        defaults =
          {
            inherit unit mappings;
            thresholds = {
              mode = "absolute";
              steps = thresholds;
            };
            color.mode = "thresholds";
          }
          // lib.filterAttrs (_: v: v != null) {inherit min max decimals;};
        overrides = [];
      };
    }
    // extra;

  stat = {
    expr,
    legend ? "",
    colorMode ? "background",
    ...
  } @ a:
    base "stat" (removeAttrs a ["expr" "legend" "colorMode"]
      // {
        w = a.w or 4;
        h = a.h or 4;
        targets = [(query {inherit expr legend;})];
        options = {
          reduceOptions = {
            calcs = ["lastNotNull"];
            fields = "";
            values = false;
          };
          inherit colorMode;
          graphMode = "none";
          textMode = "auto";
          justifyMode = "center";
        };
      });

  bars = {
    expr,
    legend,
    ...
  } @ a:
    base "bargauge" (removeAttrs a ["expr" "legend"]
      // {
        w = a.w or 6;
        h = a.h or 6;
        targets = [(query {inherit expr legend;})];
        options = {
          reduceOptions = {
            calcs = ["lastNotNull"];
            fields = "";
            values = false;
          };
          orientation = "horizontal";
          displayMode = "gradient";
          showUnfilled = true;
        };
      });

  graph = {exprs, ...} @ a:
    base "timeseries" (removeAttrs a ["exprs"]
      // {
        w = a.w or 8;
        h = a.h or 7;
        targets = lib.imap0 (i: e:
          query e
          // {refId = builtins.elemAt ["A" "B" "C" "D" "E"] i;})
        exprs;
        options = {
          legend = {
            displayMode = "list";
            placement = "bottom";
          };
          tooltip.mode = "multi";
        };
        extra.fieldConfig = {
          defaults = {
            inherit (a) unit;
            color.mode = "palette-classic";
            custom = {
              fillOpacity = 10;
              lineWidth = 1;
              showPoints = "never";
            };
          };
          overrides = [];
        };
      });

  status = labels:
    lib.mapAttrsToList (value: text: {
      type = "value";
      options.${value} = {
        inherit text;
        color =
          if value == "1"
          then "green"
          else "red";
      };
    })
    labels;

  rows = [
    {
      title = "Health";
      lines = [
        [
          (stat {
            title = "Targets down";
            expr = "count(up == 0) or vector(0)";
            thresholds = okBad;
          })
          (stat {
            title = "Failed units";
            expr = ''count(systemd_unit_state{state="failed"} == 1) or vector(0)'';
            thresholds = okBad;
          })
          (stat {
            title = "zpool";
            expr = ''node_zfs_zpool_state{state="online"}'';
            legend = "{{zpool}}";
            mappings = status {
              "1" = "ONLINE";
              "0" = "NOT ONLINE";
            };
            thresholds = steps [[null "red"] [1 "green"]];
          })
          (stat {
            title = "SMART";
            expr = "min(smartctl_device_smart_status)";
            mappings = status {
              "1" = "PASSED";
              "0" = "FAILING";
            };
            thresholds = steps [[null "red"] [1 "green"]];
          })
          (stat {
            title = "Shortest cert";
            expr = "min(traefik_tls_certs_not_after - time()) / 86400";
            unit = "d";
            decimals = 0;
            thresholds = steps [[null "red"] [7 "orange"] [14 "green"]];
          })
          (stat {
            title = "Uptime";
            expr = "time() - node_boot_time_seconds";
            unit = "s";
            colorMode = "value";
            thresholds = steps [[null "blue"]];
          })
        ]
        [
          (base "table" {
            title = "Failed units";
            w = 12;
            h = 5;
            targets = [
              (query {
                expr = ''systemd_unit_state{state="failed"} == 1'';
                instant = true;
                format = "table";
              })
            ];
            options.showHeader = false;
            extra.transformations = [
              {
                id = "organize";
                options.excludeByName = {
                  Time = true;
                  Value = true;
                  __name__ = true;
                  instance = true;
                  job = true;
                  state = true;
                };
              }
            ];
          })
          (base "alertlist" {
            title = "Firing alerts";
            w = 12;
            h = 5;
            targets = [];
            options = {
              viewMode = "list";
              showInstances = true;
              maxItems = 20;
              sortOrder = 1;
              stateFilter = {
                firing = true;
                pending = true;
                noData = false;
                normal = false;
                error = true;
              };
            };
          })
        ]
      ];
    }
    {
      title = "Resources";
      lines = [
        [
          (stat {
            title = "CPU";
            expr = ''1 - avg(rate(node_cpu_seconds_total{mode="idle"}[5m]))'';
            unit = "percentunit";
            thresholds = steps [[null "green"] [0.7 "orange"] [0.9 "red"]];
          })
          (stat {
            title = "Memory";
            expr = "1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes";
            unit = "percentunit";
            thresholds = steps [[null "green"] [0.8 "orange"] [0.9 "red"]];
          })
          (stat {
            title = "ZFS ARC";
            expr = "node_zfs_arc_size";
            unit = "bytes";
            colorMode = "value";
            thresholds = steps [[null "blue"]];
          })
          (bars {
            title = "Disk usage";
            expr = ''1 - node_filesystem_avail_bytes{mountpoint=~"/|/mnt/data"} / node_filesystem_size_bytes{mountpoint=~"/|/mnt/data"}'';
            legend = "{{mountpoint}}";
            unit = "percentunit";
            min = 0;
            max = 1;
            h = 4;
            thresholds = steps [[null "green"] [0.75 "orange"] [0.85 "red"]];
          })
          (bars {
            title = "Disk temperature";
            expr = ''smartctl_device_temperature{temperature_type="current"}'';
            legend = "{{device}}";
            unit = "celsius";
            min = 20;
            max = 70;
            h = 4;
            thresholds = steps [[null "green"] [50 "orange"] [60 "red"]];
          })
        ]
        [
          (graph {
            title = "CPU and memory";
            unit = "percentunit";
            exprs = [
              {
                expr = ''1 - avg(rate(node_cpu_seconds_total{mode="idle"}[5m]))'';
                legend = "cpu";
              }
              {
                expr = "1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes";
                legend = "memory";
              }
            ];
          })
          (graph {
            title = "Network (enp6s0)";
            unit = "Bps";
            exprs = [
              {
                expr = ''rate(node_network_receive_bytes_total{device="enp6s0"}[5m])'';
                legend = "in";
              }
              {
                expr = ''-rate(node_network_transmit_bytes_total{device="enp6s0"}[5m])'';
                legend = "out";
              }
            ];
          })
          (graph {
            title = "Disk I/O";
            unit = "Bps";
            exprs = [
              {
                expr = "sum(rate(node_disk_read_bytes_total[5m]))";
                legend = "read";
              }
              {
                expr = "-sum(rate(node_disk_written_bytes_total[5m]))";
                legend = "write";
              }
            ];
          })
        ]
      ];
    }
    {
      title = "Edge";
      lines = [
        [
          (graph {
            title = "Traefik requests by status";
            unit = "reqps";
            w = 12;
            exprs = [
              {
                expr = ''sum by (class) (label_replace(rate(traefik_service_requests_total[5m]), "class", "''${1}xx", "code", "(\\d).."))'';
                legend = "{{class}}";
              }
            ];
          })
          (bars {
            title = "Busiest services";
            expr = "topk(8, sum by (service) (rate(traefik_service_requests_total[5m])))";
            legend = "{{service}}";
            unit = "reqps";
            h = 7;
          })
          (stat {
            title = "5xx share";
            expr = ''sum(rate(traefik_service_requests_total{code=~"5.."}[5m])) / sum(rate(traefik_service_requests_total[5m]))'';
            unit = "percentunit";
            w = 3;
            h = 7;
            thresholds = steps [[null "green"] [0.01 "orange"] [0.05 "red"]];
          })
          (stat {
            title = "Local bans";
            expr = ''sum(cs_active_decisions{origin!="CAPI"}) or vector(0)'';
            w = 3;
            h = 7;
            colorMode = "value";
            thresholds = steps [[null "blue"]];
          })
        ]
      ];
    }
    {
      title = "Services";
      lines = [
        [
          (stat {
            title = "Tailnet nodes";
            expr = "headscale_nodestore_nodes";
            colorMode = "value";
            thresholds = steps [[null "blue"]];
          })
          (stat {
            title = "DNS queries";
            expr = "sum(rate(unbound_queries_total[5m]))";
            unit = "reqps";
            colorMode = "value";
            thresholds = steps [[null "blue"]];
          })
          (stat {
            title = "DNS cache hits";
            expr = "sum(rate(unbound_cache_hits_total[5m])) / (sum(rate(unbound_cache_hits_total[5m])) + sum(rate(unbound_cache_misses_total[5m])))";
            unit = "percentunit";
            colorMode = "value";
            thresholds = steps [[null "orange"] [0.5 "green"]];
          })
          (stat {
            title = "Postgres connections";
            expr = "sum(pg_stat_database_numbackends)";
            colorMode = "value";
            thresholds = steps [[null "blue"]];
          })
          (stat {
            title = "Hydra building";
            expr = "hydraqueuerunner_steps_building";
            colorMode = "value";
            thresholds = steps [[null "blue"]];
          })
          (stat {
            title = "Hydra queue";
            expr = "hydraqueuerunner_steps_runnable + hydraqueuerunner_steps_waiting";
            colorMode = "value";
            thresholds = steps [[null "blue"]];
          })
        ]
        [
          (bars {
            title = "Database sizes";
            expr = ''topk(10, pg_database_size_bytes{datname!~"template.*|postgres"})'';
            legend = "{{datname}}";
            unit = "bytes";
            w = 12;
            h = 7;
          })
          (base "dashlist" {
            title = "Dashboards";
            w = 12;
            h = 7;
            targets = [];
            options = {
              showSearch = true;
              showStarred = false;
              showRecentlyViewed = false;
              showHeadings = false;
              query = "";
              tags = [];
              maxItems = 20;
            };
          })
        ]
      ];
    }
  ];

  layout =
    (lib.foldl' (acc: row: let
        header = {
          type = "row";
          title = row.title;
          collapsed = false;
          panels = [];
          gridPos = {
            x = 0;
            y = acc.y;
            w = 24;
            h = 1;
          };
        };
        placed =
          lib.foldl' (st: line: let
            xs =
              lib.foldl' (s: p: {
                x = s.x + p.size.w;
                out =
                  s.out
                  ++ [
                    (removeAttrs p ["size"]
                      // {
                        gridPos = {
                          inherit (s) x;
                          y = st.y;
                          inherit (p.size) w h;
                        };
                      })
                  ];
              }) {
                x = 0;
                out = [];
              }
              line;
          in {
            y = st.y + lib.foldl' lib.max 0 (map (p: p.size.h) line);
            out = st.out ++ xs.out;
          }) {
            y = acc.y + 1;
            out = [];
          }
          row.lines;
      in {
        inherit (placed) y;
        out = acc.out ++ [header] ++ placed.out;
      }) {
        y = 0;
        out = [];
      }
      rows)
    .out;
in {
  uid = "sobotka-home";
  title = "sobotka";
  tags = ["home"];
  timezone = "browser";
  refresh = "30s";
  time = {
    from = "now-6h";
    to = "now";
  };
  schemaVersion = 39;
  editable = false;
  panels = lib.imap1 (i: p: p // {id = i;}) layout;
}
