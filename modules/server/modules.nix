{
  config,
  clib,
  hosts,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkMerge genAttrs mapAttrs;
  host = config.networking.hostName;
  en = clib.mkEn host;
  when = clib.mkWhen host;

  # Service definitions. `hosts` (clib scope letters) is required: the
  # service applies there and stays declared but disabled elsewhere.
  serviceDefs = {
    # infra
    glance = {
      hosts = "s";
      enable = true;
      subdomain = "dash";
      port = 8082;
    };

    authelia = {
      hosts = "s";
      enable = true;
      subdomain = "login";
      exposure = "dedicated-tunnel";
      localAlias = true;
      port = 3011;
      dashboard = {
        category = "Infra";
      };
    };

    lldap = {
      hosts = "s";
      enable = true;
      auth = false;
      port = 17170;
      dashboard = {
        icon = "lldap-dark.svg";
        category = "Infra";
      };
    };

    headscale = {
      hosts = "s";
      enable = true;
      subdomain = "hs";
      exposure = "public";
      groups = ["admins" "users"];
      auth = false;
      middlewares = ["headscale-cors"];
      port = 3004;
      dashboard = {
        path = "/admin";
        category = "Infra";
      };
    };

    pihole = {
      hosts = "sz";
      enable = true;
      port = 8053;
      dashboard = {
        name = "PiHole";
        icon = "pi-hole.svg";
        path = "/admin";
        checkPath = "/admin";
        category = "Infra";
        container.name = "pihole";
      };
    };

    grafana = {
      hosts = "s";
      enable = true;
      port = 3002;
      dashboard = {
        category = "Infra";
      };
    };

    prometheus = {
      hosts = "s";
      enable = true;
      routed = false;
      port = 9090;
    };

    uptime-kuma = {
      hosts = "s";
      enable = true;
      subdomain = "uptime";
      port = 3001;
      dashboard = {
        category = "Infra";
      };
    };

    # dev
    forgejo = {
      hosts = "s";
      enable = true;
      subdomain = "git";
      exposure = "dedicated-tunnel";
      port = 3031;
      ingress."ssh.git" = "ssh://localhost:22";
      anubis = {
        port = 8925;
        extraBots = [
          {import = "(data)/apps/gitea-rss-feeds.yaml";}
          # git over HTTPS can't solve a challenge, Forgejo does the auth
          {
            name = "git-smart-http";
            path_regex = "^/[^/]+/[^/]+/(info/refs|git-upload-pack|git-receive-pack|info/lfs/.*)$";
            action = "ALLOW";
          }
        ];
      };
      dashboard = {
        category = "Dev";
      };
    };

    hydra = {
      hosts = "s";
      enable = true;
      port = 3000;
      io = {
        writeBandwidthMax = "100M";
        writeIOPSMax = "10000";
      };
      dashboard = {
        category = "Dev";
      };
    };

    harmonia = {
      hosts = "s";
      enable = true;
      subdomain = "cache";
      exposure = "tunnel";
      port = 5000;
    };

    # media
    aurral = {
      hosts = "s";
      enable = true;
      subdomain = "aurral";
      exposure = "tunnel";
      groups = ["admins" "users"];
      port = 3009;
      dashboard = {
        icon = "aurral.webp";
        category = "Media";
        container.name = "Aurral";
      };
    };

    bazarr = {
      hosts = "s";
      enable = true;
      vpn = "arr";
      auth = false;
      port = 8687;
      dashboard = {
        category = "Media";
        container.name = "bazarr";
      };
    };

    sonarr = {
      hosts = "s";
      enable = true;
      vpn = "arr";
      auth = false;
      port = 8989;
      dashboard = {
        category = "Media";
        container.name = "sonarr";
      };
    };

    radarr = {
      hosts = "s";
      enable = true;
      vpn = "arr";
      auth = false;
      port = 7878;
      dashboard = {
        category = "Media";
        container.name = "radarr";
      };
    };

    prowlarr = {
      hosts = "s";
      enable = true;
      vpn = "arr";
      auth = false;
      port = 9696;
      dashboard = {
        category = "Media";
        container.name = "prowlarr";
      };
    };

    speedtest-tracker = {
      hosts = "s";
      enable = true;
      subdomain = "speedtest";
      auth = false;
      exposure = "local";
      port = 8280;
      dashboard = {
        category = "Infra";
        icon = "speedtest-tracker.webp";
        container.name = "speedtest-tracker";
      };
    };

    seerr = {
      hosts = "s";
      enable = true;
      exposure = "tunnel";
      port = 5055;
      anubis.port = 8924;
      dashboard = {
        category = "Media";
      };
    };

    dispatcharr = {
      hosts = "s";
      enable = true;
      vpn = "dispatcharr";
      subdomain = "tv";
      exposure = "local";
      port = 9191;
      dashboard = {
        category = "Media";
        container.name = "dispatcharr";
      };
    };

    jellyfin = {
      hosts = "s";
      enable = true;
      subdomain = "fin";
      exposure = "dedicated-tunnel";
      port = 8096;
      dashboard = {
        category = "Media";
        container.name = "jellyfin";
      };
    };

    tdarr = {
      hosts = "s";
      enable = true;
      auth = false;
      port = 8265;
      dashboard = {
        icon = "tdarr.webp";
        category = "Media";
        container = {
          name = "tdarr";
          children.node0 = "Node";
        };
      };
    };

    navidrome = {
      hosts = "s";
      enable = true;
      subdomain = "music";
      exposure = "tunnel";
      port = 4533;
      dashboard = {
        icon = "navidrome.webp";
        category = "Media";
        container.name = "navidrome";
      };
    };

    music-assistant = {
      hosts = "s";
      enable = true;
      subdomain = "ma";
      auth = false;
      port = 8095;
      dashboard = {
        category = "Media";
        container.name = "music-assistant";
      };
    };

    # downloads
    qbittorrent = {
      hosts = "s";
      enable = true;
      vpn = "qbt";
      subdomain = "qbt";
      auth = false;
      port = 8081;
      dashboard = {
        name = "qBittorrent";
        category = "Downloads";
        container.name = "qbittorrent";
      };
    };

    sabnzbd = {
      hosts = "s";
      enable = true;
      vpn = "arr";
      auth = false;
      port = 8085;
      dashboard = {
        name = "SABnzbd";
        category = "Downloads";
        container.name = "sabnzbd";
      };
    };

    slskd = {
      hosts = "s";
      enable = false;
      vpn = "slskd";
      exposure = "local";
      port = 5030;
      dashboard = {
        name = "Soulseek";
        category = "Downloads";
      };
    };

    flaresolverr = {
      hosts = "s";
      enable = true;
      vpn = "arr";
      auth = false;
      port = 8191;
      dashboard = {
        name = "FlareSolverr";
        category = "Downloads";
        container.name = "flaresolverr";
      };
    };

    # cloud
    immich = {
      hosts = "s";
      enable = true;
      exposure = "tailscale";
      groups = ["admins" "users"];
      port = 2283;
      dashboard = {
        category = "Cloud";
        checkUrl = "http://localhost:2283/api/server/ping";
      };
    };

    memos = {
      hosts = "s";
      enable = true;
      exposure = "tailscale";
      groups = ["admins" "users"];
      port = 5230;
      dashboard = {
        category = "Cloud";
      };
    };

    vaultwarden = {
      hosts = "s";
      enable = true;
      subdomain = "vault";
      exposure = "dedicated-tunnel";
      port = 8222;
      securityHeaders = false;
      dashboard = {
        icon = "vaultwarden-light.svg";
        category = "Cloud";
      };
    };

    # communication
    fluxer = {
      hosts = "s";
      enable = false;
      subdomain = "chat";
      exposure = "public";
      port = 8480;
      dashboard = {
        category = "Communication";
      };
    };

    miniflux = {
      hosts = "s";
      enable = true;
      subdomain = "feed";
      port = 8087;
      dashboard = {
        category = "Communication";
        container.name = "miniflux";
      };
    };

    ntfy = {
      hosts = "s";
      enable = true;
      port = 2586;
      exposure = "tailscale";
      auth = false;
      dashboard = {
        category = "Communication";
      };
    };

    roundcube = {
      hosts = "s";
      enable = false;
      subdomain = "mail";
      port = 5679;
      dashboard = {
        category = "Communication";
      };
    };

    # automation
    home-assistant = {
      hosts = "s";
      enable = true;
      subdomain = "ha";
      exposure = "tailscale";
      port = 8123;
      dashboard = {
        category = "Automation";
        container.name = "home-assistant";
      };
    };

    ollama = {
      hosts = "s";
      enable = false;
      exposure = "local";
      port = 8001;
      dashboard = {
        category = "Automation";
      };
    };
  };
in {
  config.age.secrets.smtp = when "s" {
    file = "${self}/secrets/smtp.age";
  };

  config.cnix.server = {
    enable = true;
    publicIp = "185.147.236.7";
    mediaDir = "/mnt/data";
    user = "share";
    group = "share";
    uid = 2000;
    gid = 2000;

    smtp = {
      host = "smtp.protonmail.ch:587";
      user = "noreply@cnst.dev";
      from = "noreply@cnst.dev";
      passwordFile = config.age.secrets.smtp.path;
    };

    tailnet.ip = "100.64.88.2";
    tailnet.groups = {
      admins = ["cnst@cnix.dev"];
      users = ["fredrik@libellux.com"];
    };

    infra = {
      traefik = en "s";
      tailscale = en "s";
      gluetun = when "s" {
        enable = true;
        instances = {
          qbt = {
            ip = "10.88.0.250";
            extraOptions = [
              "--health-cmd=wget -qO- https://ipinfo.io/ip || exit 1"
              "--health-interval=10s"
              "--health-retries=6"
              "--health-start-period=30s"
            ];
          };
          arr = {
            ip = "10.88.0.251";
            controlPort = 8003; # glance's gluetun widget (GLUETUN_URL)
            peers = ["qbt"];
            disableIpv6 = true;
          };
          dispatcharr = {};
          slskd.extraPorts = ["8388:8388" "127.0.0.1:5031:5031" "50323:50323"];
        };
      };
      podman = en "sz";

      unbound = when {
        "sz" = {
          enable = true;
          serviceIp = hosts.sobotka.ip;
          extraAllowedSubnets = ["192.168.20.0/24"];
        };
        "s" = {
          profile = "large";
          ioLatencyDevices = ["259:0" "254:2"];
        };
        "z" = {
          profile = "small";
          # ziggy can't see sobotka's service defs; keep its two fixed names.
          extraNames = map (s: "${s}.${config.cnix.settings.site.domains.local}") ["traefik" "login"];
        };
      };

      keepalived = when "sz" {
        enable = true;
        members = ["sobotka" "ziggy"];
        priority = when {
          "s" = 20;
          "z" = 10;
        };
        healthCheck = "${pkgs.ldns}/bin/drill -Q -p 5335 @127.0.0.1 . SOA";
        interface = when {
          "s" = "enp6s0";
          "z" = "enu1u1";
        };
      };

      crowdsec = en "s";

      cron.jobs = when "s" {
        update-images = {
          script = "update-images";
          schedule = "Mon *-*-* 04:00";
        };
      };

      fail2ban = when "s" {
        enable = true;
        apiKeyFile = config.age.secrets.cloudflareFirewallApiKey.path;
        zoneId = "0027acdfb8bbe010f55b676ad8698dfb";
      };

      www = when "s" {
        enable = true;
        port = 8283;
        cloudflared = {
          tunnelId = "e5076186-efb7-405a-998c-6155af7fb221";
          credentialsFile = config.age.secrets.wwwCloudflared.path;
        };
      };
    };

    services = mkMerge [
      (genAttrs (builtins.attrNames serviceDefs) (_: {}))
      (mapAttrs (name: d:
        when (d.hosts or (throw "modules/server/modules.nix: service `${name}` needs `hosts`"))
        (removeAttrs d ["hosts"]))
      serviceDefs)
    ];
  };
}
