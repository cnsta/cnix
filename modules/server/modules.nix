{
  config,
  clib,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge genAttrs;
  host = config.networking.hostName;
  ip = config.cnix.settings.network.localIp;
  en = clib.mkEn host;
  when = clib.mkWhen host;

  serviceDefs = {
    # infra
    glance = when "s" {
      enable = true;
      subdomain = "dash";
      port = 8082;
    };

    authelia = when "s" {
      enable = true;
      subdomain = "login";
      exposure = "tunnel";
      port = 3011;
      cloudflared = {
        tunnelId = "5c598772-1ea9-495f-bf3b-1feb064bfc29";
        credentialsFile = config.age.secrets.autheliaCloudflared.path;
      };
      dashboard = {
        category = "Infra";
      };
    };

    lldap = when "s" {
      enable = true;
      auth = false;
      port = 17170;
      dashboard = {
        icon = "lldap-dark.svg";
        category = "Infra";
      };
    };

    headscale = when "s" {
      enable = true;
      subdomain = "hs";
      exposure = "tunnel";
      tunnelViaTraefik = true;
      auth = false;
      middlewares = ["headscale-cors"];
      port = 3004;
      dashboard = {
        path = "/admin";
        category = "Infra";
      };
    };

    pihole = when "sz" {
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

    grafana = when "s" {
      enable = true;
      port = 3002;
      dashboard = {
        category = "Infra";
      };
    };

    uptime-kuma = when "s" {
      enable = true;
      subdomain = "uptime";
      port = 3001;
      dashboard = {
        category = "Infra";
      };
    };

    # dev
    forgejo = when "s" {
      enable = true;
      subdomain = "git";
      exposure = "dedicated-tunnel";
      port = 3031;
      ingress."ssh.git" = "ssh://localhost:22";
      dashboard = {
        category = "Dev";
      };
    };

    hydra = when "s" {
      enable = true;
      port = 3000;
      dashboard = {
        category = "Dev";
      };
    };

    harmonia = when "s" {
      enable = true;
      subdomain = "cache";
      exposure = "tunnel";
      port = 5000;
    };

    # media
    arr = when "s" {
      enable = true;
      routed = false;
    };

    sonarr = when "s" {
      enable = true;
      auth = false;
      port = 8989;
      dashboard = {
        category = "Media";
        container.name = "sonarr";
      };
    };

    radarr = when "s" {
      enable = true;
      auth = false;
      port = 7878;
      dashboard = {
        category = "Media";
        container.name = "radarr";
      };
    };

    lidarr = when "s" {
      enable = true;
      auth = false;
      port = 8686;
      dashboard = {
        category = "Media";
        container.name = "lidarr";
      };
    };

    prowlarr = when "s" {
      enable = true;
      auth = false;
      port = 9696;
      dashboard = {
        category = "Media";
        container.name = "prowlarr";
      };
    };

    speedtest-tracker = when "s" {
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

    sportarr = when "s" {
      enable = false;
      exposure = "local";
      port = 1867;
      dashboard = {
        category = "Media";
      };
    };

    seerr = when "s" {
      enable = true;
      exposure = "tunnel";
      port = 5055;
      dashboard = {
        category = "Media";
      };
    };

    jellyfin = when "s" {
      enable = true;
      subdomain = "fin";
      exposure = "dedicated-tunnel";
      port = 8096;
      dashboard = {
        category = "Media";
        container.name = "jellyfin";
      };
    };

    tdarr = when "s" {
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

    navidrome = when "s" {
      enable = true;
      auth = false;
      port = 4533;
      dashboard = {
        icon = "navidrome.webp";
        category = "Media";
        container.name = "navidrome";
      };
    };

    octo-fiesta = when "s" {
      enable = true;
      subdomain = "music";
      exposure = "tunnel";
      port = 8089;
      dashboard = {
        name = "Octo-Fiesta";
        icon = "navidrome.webp";
        category = "Media";
        container.name = "octo-fiesta";
      };
    };

    music-assistant = when "s" {
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
    qbittorrent = when "s" {
      enable = true;
      subdomain = "qbt";
      auth = false;
      port = 8081;
      dashboard = {
        name = "qBittorrent";
        category = "Downloads";
        container.name = "qbittorrent";
      };
    };

    sabnzbd = when "s" {
      enable = true;
      auth = false;
      port = 8085;
      dashboard = {
        name = "SABnzbd";
        category = "Downloads";
        container.name = "sabnzbd";
      };
    };

    slskd = {
      enable = false;
      exposure = "local";
      port = 5030;
      dashboard = {
        name = "Soulseek";
        category = "Downloads";
      };
    };

    flaresolverr = when "s" {
      enable = true;
      auth = false;
      port = 8191;
      dashboard = {
        name = "FlareSolverr";
        category = "Downloads";
        container.name = "flaresolverr";
      };
    };

    # cloud
    immich = when "s" {
      enable = true;
      exposure = "tailscale";
      port = 2283;
      dashboard = {
        category = "Cloud";
        checkUrl = "http://localhost:2283/api/server/ping";
      };
    };

    memos = when "s" {
      enable = true;
      exposure = "tailscale";
      port = 5230;
      dashboard = {
        category = "Cloud";
      };
    };

    vaultwarden = when "s" {
      enable = true;
      subdomain = "vault";
      exposure = "tunnel";
      port = 8222;
      cloudflared = {
        tunnelId = "fdd98086-6a4c-44f2-bba0-eb86b833cce5";
        credentialsFile = config.age.secrets.vaultwardenCloudflared.path;
      };
      dashboard = {
        icon = "vaultwarden-light.svg";
        category = "Cloud";
      };
    };

    nextcloud = {
      enable = false;
      subdomain = "cloud";
      exposure = "local";
      port = 8182;
      dashboard = {
        category = "Cloud";
      };
    };

    searxng = when "s" {
      enable = false;
      subdomain = "search";
      exposure = "local";
      port = 8084;
      dashboard = {
        name = "SearXNG";
        category = "Cloud";
      };
    };

    # communication
    fluxer = when "s" {
      enable = true;
      subdomain = "chat";
      exposure = "tailscale";
      port = 8480;
      dashboard = {
        category = "Communication";
      };
    };

    miniflux = when "s" {
      enable = true;
      subdomain = "feed";
      port = 8087;
      dashboard = {
        category = "Communication";
        container.name = "miniflux";
      };
    };

    roundcube = when "s" {
      enable = true;
      subdomain = "mail";
      port = 5679;
      dashboard = {
        category = "Communication";
      };
    };

    # automation
    home-assistant = when "s" {
      enable = true;
      subdomain = "ha";
      auth = false;
      port = 8123;
      dashboard = {
        category = "Automation";
        container.name = "home-assistant";
      };
    };

    ollama = {
      enable = false;
      exposure = "local";
      port = 8001;
      dashboard = {
        category = "Automation";
      };
    };

    n8n = {
      enable = false;
      exposure = "local";
      port = 5678;
      dashboard = {
        name = "n8n";
        category = "Automation";
      };
    };

    turnstone = {
      enable = false;
      exposure = "tailscale";
      port = 8098;
      dashboard = {
        category = "Automation";
      };
    };
  };
in {
  config.cnix.server = {
    enable = true;
    email = "adam@cnst.dev";
    domain = "cnix.dev";
    ip = ip;
    user = "share";
    group = "share";
    uid = 994;
    gid = 993;

    infra = {
      traefik = en "s";
      tailscale = en "s";
      gluetun = en "s";
      podman = en "sz";

      unbound = when {
        "sz" = {
          enable = true;
          serviceIp = "192.168.88.14";
        };
        "s" = {
          profile = "large";
          ioLatencyDevices = ["259:0" "254:2"];
        };
        "z".profile = "small";
      };

      keepalived = when "sz" {
        enable = true;
        healthCheck = "${pkgs.ldns}/bin/drill -Q -p 5335 @127.0.0.1 . SOA";
        interface = when {
          "s" = "enp6s0";
          "z" = "enu1u1";
        };
      };

      fail2ban = when "s" {
        enable = true;
        apiKeyFile = config.age.secrets.cloudflareFirewallApiKey.path;
        zoneId = "0027acdfb8bbe010f55b676ad8698dfb";
      };

      www = when "s" {
        enable = true;
        url = "cnst.dev";
        port = 8283;
        cloudflared = {
          tunnelId = "e5076186-efb7-405a-998c-6155af7fb221";
          credentialsFile = config.age.secrets.wwwCloudflared.path;
        };
      };
    };

    services = mkMerge [
      (genAttrs (builtins.attrNames serviceDefs) (_: {}))
      serviceDefs
    ];
  };
}
