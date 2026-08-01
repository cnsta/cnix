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
    homepage = when "s" {
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
      homepage = {
        description = "Authentication and authorization server";
        category = "Infra";
      };
    };

    lldap = when "s" {
      enable = true;
      auth = false;
      port = 17170;
      homepage = {
        name = "lldap";
        description = "Light LDAP implementation for authentication";
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
      homepage = {
        description = "Coordination server for Tailscale";
        path = "/admin";
        category = "Infra";
      };
    };

    pihole = when "sz" {
      enable = true;
      port = 8053;
      homepage = {
        name = "PiHole";
        icon = "pi-hole.svg";
        description = "Adblocking and DNS service";
        path = "/admin";
        category = "Infra";
      };
    };

    grafana = when "s" {
      enable = true;
      port = 3002;
      homepage = {
        description = "Full-stack observability";
        category = "Infra";
      };
    };

    uptime-kuma = when "s" {
      enable = true;
      subdomain = "uptime";
      port = 3001;
      homepage = {
        description = "Service monitoring tool";
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
      homepage = {
        description = "A painless, self-hosted Git service";
        category = "Dev";
      };
    };

    hydra = when "s" {
      enable = true;
      port = 3000;
      homepage = {
        description = "Nix continuous integration";
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
      homepage = {
        description = "Internet PVR for Usenet and Torrents";
        category = "Media";
      };
    };

    radarr = when "s" {
      enable = true;
      auth = false;
      port = 7878;
      homepage = {
        description = "Movie collection manager";
        category = "Media";
      };
    };

    lidarr = when "s" {
      enable = true;
      auth = false;
      port = 8686;
      homepage = {
        description = "Music collection manager";
        category = "Media";
      };
    };

    prowlarr = when "s" {
      enable = true;
      auth = false;
      port = 9696;
      homepage = {
        description = "PVR indexer";
        category = "Media";
      };
    };

    sportarr = when "s" {
      enable = false;
      exposure = "local";
      port = 1867;
      homepage = {
        description = "Sports PVR for Usenet and Torrents";
        category = "Media";
      };
    };

    seerr = when "s" {
      enable = true;
      exposure = "tailscale";
      port = 5055;
      homepage = {
        description = "Media request and discovery manager";
        category = "Media";
      };
    };

    jellyfin = when "s" {
      enable = true;
      subdomain = "fin";
      exposure = "tailscale";
      port = 8096;
      homepage = {
        description = "The Free Software Media System";
        category = "Media";
      };
    };

    tdarr = when "s" {
      enable = true;
      auth = false;
      port = 8265;
      homepage = {
        icon = "tdarr.webp";
        description = "Media transcoding application";
        category = "Media";
      };
    };

    navidrome = when "s" {
      enable = true;
      auth = false;
      port = 4533;
      homepage = {
        icon = "navidrome.webp";
        description = "Music streaming service";
        category = "Media";
      };
    };

    octo-fiesta = when "s" {
      enable = true;
      subdomain = "music";
      exposure = "tunnel";
      port = 8089;
      homepage = {
        name = "Octo-Fiesta";
        icon = "navidrome.webp";
        description = "Subsonic proxy";
        category = "Media";
      };
    };

    # downloads
    qbittorrent = when "s" {
      enable = true;
      subdomain = "qbt";
      auth = false;
      port = 8081;
      homepage = {
        name = "qBittorrent";
        description = "Torrent client";
        category = "Downloads";
      };
    };

    sabnzbd = when "s" {
      enable = true;
      auth = false;
      port = 8085;
      homepage = {
        name = "SABnzbd";
        description = "Free and easy binary newsreader";
        category = "Downloads";
      };
    };

    slskd = {
      enable = false;
      exposure = "local";
      port = 5030;
      homepage = {
        name = "Soulseek";
        description = "Web-based Soulseek client";
        category = "Downloads";
      };
    };

    flaresolverr = when "s" {
      enable = true;
      auth = false;
      port = 8191;
      homepage = {
        name = "FlareSolverr";
        description = "Proxy to bypass Cloudflare/DDoS-GUARD protection";
        category = "Downloads";
      };
    };

    # cloud
    immich = when "s" {
      enable = true;
      exposure = "tailscale";
      port = 2283;
      homepage = {
        description = "Photo collection manager";
        category = "Cloud";
      };
    };

    memos = when "s" {
      enable = true;
      exposure = "tailscale";
      port = 5230;
      homepage = {
        description = "Open-source, self-hosted note-taking";
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
      homepage = {
        icon = "vaultwarden-light.svg";
        description = "Password manager";
        category = "Cloud";
      };
    };

    nextcloud = {
      enable = false;
      subdomain = "cloud";
      exposure = "local";
      port = 8182;
      homepage = {
        description = "A safe home for all your data";
        category = "Cloud";
      };
    };

    searxng = when "s" {
      enable = false;
      subdomain = "search";
      exposure = "local";
      port = 8084;
      homepage = {
        name = "SearXNG";
        description = "Internet metasearch engine";
        category = "Cloud";
      };
    };

    # communication
    fluxer = when "s" {
      enable = true;
      subdomain = "chat";
      exposure = "tailscale";
      port = 8480;
      homepage = {
        description = "Open source chat for friends and communities";
        category = "Communication";
      };
    };

    miniflux = when "s" {
      enable = true;
      subdomain = "feed";
      port = 8087;
      homepage = {
        description = "A minimalist and opinionated feed reader";
        category = "Communication";
      };
    };

    roundcube = when "s" {
      enable = true;
      subdomain = "mail";
      port = 5679;
      homepage = {
        description = "Browser-based multilingual IMAP client";
        category = "Communication";
      };
    };

    # automation
    home-assistant = when "s" {
      enable = true;
      subdomain = "ha";
      auth = false;
      port = 8123;
      homepage = {
        description = "Awaken your home";
        category = "Automation";
      };
    };

    ollama = {
      enable = false;
      exposure = "local";
      port = 8001;
      homepage = {
        description = "AI platform";
        category = "Automation";
      };
    };

    n8n = {
      enable = false;
      exposure = "local";
      port = 5678;
      homepage = {
        name = "n8n";
        description = "A workflow automation platform";
        category = "Automation";
      };
    };

    turnstone = {
      enable = false;
      exposure = "tailscale";
      port = 8098;
      homepage = {
        description = "Multi-node AI orchestration platform";
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
