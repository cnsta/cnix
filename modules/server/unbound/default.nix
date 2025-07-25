{
  lib,
  pkgs,
  config,
  ...
}: let
  unit = "unbound";
  cfg = config.server.${unit};
in {
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      # resolved.enable = lib.mkForce false;
      unbound = {
        enable = true;
        enableRootTrustAnchor = true;
        localControlSocketPath = "/run/unbound/unbound.ctl";
        resolveLocalQueries = true;
        package = pkgs.unbound-full;
        settings = {
          server = {
            aggressive-nsec = true;
            cache-max-ttl = 86400;
            cache-min-ttl = 300;
            delay-close = 10000;
            deny-any = true;
            do-ip4 = true;
            do-ip6 = true;
            do-tcp = true;
            do-udp = true;
            prefer-ip6 = false;
            edns-buffer-size = "1232";
            extended-statistics = true;
            harden-algo-downgrade = true;
            harden-below-nxdomain = true;
            harden-dnssec-stripped = true;
            harden-glue = true;
            harden-large-queries = true;
            harden-short-bufsize = true;
            infra-cache-slabs = 8;
            interface = [
              "127.0.0.1@5335"
              "::@5335"
            ];
            key-cache-slabs = 8;
            msg-cache-size = "256m";
            msg-cache-slabs = 8;
            neg-cache-size = "256m";
            num-queries-per-thread = 4096;
            num-threads = 4;
            outgoing-range = 8192;
            prefetch = true;
            prefetch-key = true;
            qname-minimisation = true;
            rrset-cache-size = "256m";
            rrset-cache-slabs = 8;
            rrset-roundrobin = true;
            serve-expired = true;
            so-rcvbuf = "2m";
            so-reuseport = true;
            so-sndbuf = "2m";
            statistics-cumulative = true;
            statistics-interval = 0;
            tls-cert-bundle = "/etc/ssl/certs/ca-certificates.crt";
            unwanted-reply-threshold = 100000;
            use-caps-for-id = false;
            verbosity = 1;
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
            private-domain = ["local"];
            domain-insecure = ["local"];
          };
        };
      };
    };
  };
}
