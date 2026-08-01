{
  lib,
  clib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types mkIf;

  unit = "unbound";
  cfg = config.cnix.server.infra.${unit};
  srv = config.cnix.server;

  localIp = config.cnix.settings.network.localIp;
  domains = config.cnix.settings.accounts.domains;

  tuning =
    {
      small = {
        package = pkgs.unbound-with-systemd;
        threads = 2;
        slabs = 2;
        msgCache = "16m";
        rrsetCache = "32m";
        negCache = "4m";
        outgoingRange = 1024;
        queriesPerThread = 512;
        sockBuf = "512k";
        memoryMin = "96M";
        memoryHigh = "192M";
      };
      large = {
        package = pkgs.unbound-full;
        threads = 4;
        slabs = 8;
        msgCache = "256m";
        rrsetCache = "256m";
        negCache = "16m";
        outgoingRange = 8192;
        queriesPerThread = 4096;
        sockBuf = "2m";
        memoryMin = "512M";
        memoryHigh = "1G";
      };
    }
    .${
      cfg.profile
    };

  localARecords =
    lib.mapAttrsToList
    (_: s: ''"${clib.server.mkFullDomain config s}. A ${cfg.serviceIp}"'')
    (lib.filterAttrs
      (_: s: s.enable && s.routed && s.subdomain != "")
      srv.services);
in {
  options.cnix.server.infra.${unit} = {
    enable = mkEnableOption "recursive DNS resolution with unbound";

    profile = mkOption {
      type = types.enum ["small" "large"];
      default = "large";
      description = ''
        Resource envelope for cache sizes, thread count and socket buffers.
        Use "small" on hosts with 1GB RAM or less.
      '';
    };

    serviceIp = mkOption {
      type = types.str;
      default = srv.ip;
      defaultText = lib.literalExpression "config.cnix.server.ip";
      description = ''
        Address that generated A records point at. This is the host running
        Traefik, which is not necessarily the host running unbound, the DNS
        backup resolves service names to the primary, not to itself.
      '';
    };

    listenPort = mkOption {
      type = types.port;
      default = 5335;
      description = "Port unbound listens on. Pi-hole holds :53 and forwards here.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Open :53 for Pi-hole and :5335 for the podman bridge. Required on
        every host that can hold the keepalived VIP.
      '';
    };

    ioLatencyDevices = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["259:0" "254:2"];
      description = ''
        major:minor of block devices backing the DNS working set, for
        io.latency protection. Find them with `lsblk -o NAME,MAJ:MIN`.
        Leave empty to skip; wrong values are ignored rather than fatal.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = localIp != "" && localIp != "127.0.0.1";
        message = ''
          cnix.server.infra.unbound: cnix.settings.network.localIp is unset on
          ${config.networking.hostName}. unbound would bind loopback twice and
          never answer on the LAN.
        '';
      }
      {
        assertion = domains.local != "" && domains.public != "";
        message = ''
          cnix.server.infra.unbound: cnix.settings.accounts.domains is unset on
          ${config.networking.hostName}. Generated records would be nonsense
          (this is what produced `pihole.127.0.0.1`).
        '';
      }
    ];

    boot.kernel.sysctl = {
      "net.core.rmem_max" = lib.mkDefault 4194304;
      "net.core.wmem_max" = lib.mkDefault 4194304;
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [53];
      allowedUDPPorts = [53];
      interfaces."podman0" = {
        allowedTCPPorts = [cfg.listenPort];
        allowedUDPPorts = [cfg.listenPort];
      };
    };

    systemd = {
      slices.system-dns = {
        description = "Latency-sensitive DNS services";
        sliceConfig = {
          MemoryMin = tuning.memoryMin;
          MemoryHigh = tuning.memoryHigh;
        };
      };

      services = {
        unbound.serviceConfig = {
          Slice = "system-dns.slice";
          LimitNOFILE = tuning.threads * tuning.outgoingRange + 4096;
        };

        dns-io-latency = mkIf (cfg.ioLatencyDevices != []) {
          description = "Apply io.latency protection to system-dns.slice";
          wantedBy = ["multi-user.target"];
          after = ["unbound.service" "podman-pihole.service"];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            p=/sys/fs/cgroup/system.slice/system-dns.slice/io.latency
            if [ ! -e "$p" ]; then
              echo "io.latency unavailable (no cgroup v2 io controller); skipping"
              exit 0
            fi
            ${lib.concatMapStringsSep "\n" (dev: ''
                echo "${dev} target=20" > "$p" \
                  || echo "warning: could not set io.latency for ${dev}"
              '')
              cfg.ioLatencyDevices}
          '';
        };
      };
    };

    services.${unit} = {
      enable = true;
      package = tuning.package;
      enableRootTrustAnchor = true;
      localControlSocketPath = "/run/unbound/unbound.ctl";
      resolveLocalQueries = true;

      settings.server = {
        interface = [
          "127.0.0.1@${toString cfg.listenPort}"
          "::1@${toString cfg.listenPort}"
          "${localIp}@${toString cfg.listenPort}"
        ];

        access-control = [
          "127.0.0.0/8 allow"
          "::1 allow"
          "10.88.0.0/24 allow"
          "192.168.88.0/24 allow"
          "192.168.20.0/24 allow"
          "100.64.88.0/24 allow"
          "fd7a:115c:a1e0:88::/64 allow"
          "0.0.0.0/0 refuse"
          "::0/0 refuse"
        ];

        # sizing
        num-threads = tuning.threads;
        infra-cache-slabs = tuning.slabs;
        key-cache-slabs = tuning.slabs;
        msg-cache-slabs = tuning.slabs;
        rrset-cache-slabs = tuning.slabs;
        msg-cache-size = tuning.msgCache;
        rrset-cache-size = tuning.rrsetCache;
        neg-cache-size = tuning.negCache;
        outgoing-range = tuning.outgoingRange;
        num-queries-per-thread = tuning.queriesPerThread;
        so-rcvbuf = tuning.sockBuf;
        so-sndbuf = tuning.sockBuf;
        so-reuseport = true;

        # caching behaviour
        cache-max-ttl = 86400;
        cache-min-ttl = 300;
        prefetch = true;
        prefetch-key = true;
        serve-expired = true;
        serve-expired-ttl = 86400;
        serve-expired-client-timeout = 1800;
        rrset-roundrobin = true;

        # hardening
        aggressive-nsec = true;
        deny-any = true;
        harden-algo-downgrade = true;
        harden-below-nxdomain = true;
        harden-dnssec-stripped = true;
        harden-glue = true;
        harden-large-queries = true;
        harden-short-bufsize = true;
        hide-identity = true;
        hide-version = true;
        qname-minimisation = true;
        use-caps-for-id = false;
        unwanted-reply-threshold = 10000000;
        delay-close = 10000;

        private-address = [
          "10.0.0.0/8"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "fd00::/8"
          "fe80::/10"
          "192.0.2.0/24"
          "198.51.100.0/24"
          "203.0.113.0/24"
          "255.255.255.255/32"
          "2001:db8::/32"
        ];

        # transport
        do-ip4 = true;
        do-ip6 = true;
        do-tcp = true;
        do-udp = true;
        prefer-ip6 = false;
        edns-buffer-size = "1232";
        ip-freebind = true;
        tls-cert-bundle = "/etc/ssl/certs/ca-certificates.crt";

        # observability
        extended-statistics = true;
        statistics-cumulative = true;
        statistics-interval = 0;
        verbosity = 1;

        # local authority
        local-zone = [
          ''"${domains.local}." transparent''
          ''"${domains.public}." transparent''
          ''"ts.${domains.public}." transparent''
        ];

        local-data =
          [
            ''"traefik.${domains.local}. A ${cfg.serviceIp}"''
            ''"login.${domains.local}. A ${cfg.serviceIp}"''
          ]
          ++ localARecords;
      };
    };
  };
}
