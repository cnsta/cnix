{
  config,
  clib,
  ...
}:
let
  host = config.networking.hostName;
  ip = config.cnix.settings.network.localIp;
  en = clib.mkEn host;
  when = clib.mkWhen host;
  none = clib.mkNone host;
in
{
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
      traefik = en "sz";
      tailscale = en "s";
      unbound = en "sz";
      gluetun = en "s";
      podman = en "sz";

      cnixpost = {
        enable = none;
        clamav.enable = true;
        accounts."cnst@cnix.dev" = {
          quota = "10G";
          aliases = [
            "postmaster@cnix.dev"
            "abuse@cnix.dev"
            "tls-reports@cnix.dev"
          ];
        };
        dkimSelector = "mail";
        mtaSts = {
          enable = true;
          mode = "testing";
          policyId = "20250101000000"; # TODO: update when policy content changes
          mxHosts = [ "mail.cnix.dev" ];
        };
        spamScoreAddHeader = 4.0;
        spamScoreGreylist = 6.0;
        spamScoreReject = 15.0;
      };

      authentik = when "s" {
        enable = true;
        url = "auth.cnst.dev";
        port = 9000;
        cloudflared = {
          tunnelId = "b66f9368-db9e-4302-8b48-527cda34a635";
          credentialsFile = config.age.secrets.authentikCloudflared.path;
        };
      };

      fail2ban = when "s" {
        enable = true;
        apiKeyFile = config.age.secrets.cloudflareFirewallApiKey.path;
        zoneId = "0027acdfb8bbe010f55b676ad8698dfb";
      };

      keepalived = when "s" {
        enable = true;
        interface = "enp6s0";
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

    services = {
      homepage = when "s" {
        enable = true;
        subdomain = "dash";
        exposure = "local";
        port = 8082;
      };

      hydra = when "s" {
        enable = true;
        subdomain = "hydra";
        exposure = "local";
        port = 3000;
        homepage = {
          name = "Hydra";
          description = "Nix continuous integration";
          icon = "hydra.svg";
          category = "Dev";
        };
      };

      harmonia = when "s" {
        enable = true;
        subdomain = "cache";
        exposure = "tunnel";
        port = 5000;
      };

      arr = when "s" {
        enable = true;
        routed = false;
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
          name = "Authelia";
          description = "Authentication and authorization server";
          icon = "authelia.svg";
          category = "Infra";
        };
      };

      cinny = when "s" {
        enable = true;
        subdomain = "cinny";
        exposure = "tunnel";
        port = 8088;
        homepage = {
          name = "Cinny";
          description = "Matrix client";
          icon = "cinny.svg";
          category = "Communication";
        };
      };

      memos = when "s" {
        enable = true;
        subdomain = "memos";
        exposure = "tailscale";
        port = 5230;
        homepage = {
          name = "Memos";
          description = "Open-source, self-hosted note-taking";
          icon = "memos.svg";
          category = "Cloud";
        };
      };

      n8n = {
        enable = false;
        subdomain = "n8n";
        exposure = "local";
        port = 5678;
        homepage = {
          name = "n8n";
          description = "A workflow automation platform";
          icon = "n8n.svg";
          category = "Automation";
        };
      };

      freshrss = {
        enable = false;
        subdomain = "rss";
        exposure = "local";
        port = 8002;
        homepage = {
          name = "FreshRSS";
          description = "Self-hosted RSS and Atom feed aggregator";
          icon = "freshrss.svg";
          category = "Media";
        };
      };

      searxng = when "s" {
        enable = true;
        subdomain = "search";
        exposure = "local";
        port = 8084;
        homepage = {
          name = "SearXNG";
          description = "Internet metasearch engine";
          icon = "searxng.svg";
          category = "Cloud";
        };
      };

      ollama = {
        enable = false;
        subdomain = "ai";
        exposure = "local";
        port = 8001;
        homepage = {
          name = "ollama";
          description = "AI platform";
          icon = "ollama.svg";
          category = "Automation";
        };
      };

      bazarr = when "s" {
        enable = true;
        subdomain = "bazarr";
        exposure = "local";
        port = 6767;
        homepage = {
          name = "Bazarr";
          description = "Subtitle manager";
          icon = "bazarr.svg";
          category = "Media";
        };
      };

      prowlarr = when "s" {
        enable = true;
        subdomain = "prowlarr";
        exposure = "local";
        port = 9696;
        homepage = {
          name = "Prowlarr";
          description = "PVR indexer";
          icon = "prowlarr.svg";
          category = "Media";
        };
      };

      flaresolverr = when "s" {
        enable = true;
        subdomain = "flaresolverr";
        exposure = "local";
        port = 8191;
        homepage = {
          name = "FlareSolverr";
          description = "Proxy to bypass Cloudflare/DDoS-GUARD protection";
          icon = "flaresolverr.svg";
          category = "Downloads";
        };
      };

      grafana = when "s" {
        enable = true;
        subdomain = "grafana";
        exposure = "local";
        port = 3002;
        homepage = {
          name = "Grafana";
          description = "Full-stack observability";
          icon = "grafana.svg";
          category = "Infra";
        };
      };

      immich = when "s" {
        enable = true;
        subdomain = "immich";
        exposure = "tailscale";
        port = 2283;
        homepage = {
          name = "immich";
          description = "Photo collection manager";
          icon = "immich.svg";
          category = "Cloud";
        };
      };

      lidarr = when "s" {
        enable = true;
        subdomain = "lidarr";
        exposure = "local";
        port = 8686;
        homepage = {
          name = "Lidarr";
          description = "Music collection manager";
          icon = "lidarr.svg";
          category = "Media";
        };
      };

      sonarr = when "s" {
        enable = true;
        subdomain = "sonarr";
        exposure = "local";
        port = 8989;
        homepage = {
          name = "Sonarr";
          description = "Internet PVR for Usenet and Torrents";
          icon = "sonarr.svg";
          category = "Media";
        };
      };

      radarr = when "s" {
        enable = true;
        subdomain = "radarr";
        exposure = "local";
        port = 7878;
        homepage = {
          name = "Radarr";
          description = "Movie collection manager";
          icon = "radarr.svg";
          category = "Media";
        };
      };

      navidrome = when "s" {
        enable = true;
        subdomain = "music";
        exposure = "tunnel";
        port = 4533;
        homepage = {
          name = "Navidrome";
          description = "Music streaming service";
          icon = "navidrome.svg";
          category = "Media";
        };
      };

      roundcube = when "s" {
        enable = true;
        subdomain = "mail";
        exposure = "local";
        port = 5679;
        homepage = {
          name = "Roundcube";
          description = "Browser-based multilingual IMAP client";
          icon = "roundcube.svg";
          category = "Communication";
        };
      };

      seerr = when "s" {
        enable = true;
        subdomain = "seerr";
        exposure = "tailscale";
        port = 5055;
        homepage = {
          name = "Seerr";
          description = "Media request and discovery manager";
          icon = "jellyseerr.svg";
          category = "Media";
        };
      };

      jellyfin = when "s" {
        enable = true;
        subdomain = "fin";
        exposure = "tailscale";
        port = 8096;
        homepage = {
          name = "Jellyfin";
          description = "The Free Software Media System";
          icon = "jellyfin.svg";
          category = "Media";
        };
      };

      uptime-kuma = when "s" {
        enable = true;
        subdomain = "uptime";
        exposure = "local";
        port = 3001;
        homepage = {
          name = "Uptime Kuma";
          description = "Service monitoring tool";
          icon = "uptime-kuma.svg";
          category = "Infra";
        };
      };

      lldap = when "s" {
        enable = true;
        subdomain = "lldap";
        exposure = "local";
        port = 17170;
        homepage = {
          name = "lldap";
          description = "Light LDAP implementation for authentication";
          icon = "lldap.svg";
          category = "Infra";
        };
      };

      forgejo = when "s" {
        enable = true;
        subdomain = "git";
        exposure = "tunnel";
        port = 3031;
        homepage = {
          name = "Forgejo";
          description = "A painless, self-hosted Git service";
          icon = "forgejo.svg";
          category = "Dev";
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
          name = "Vaultwarden";
          description = "Password manager";
          icon = "vaultwarden-light.svg";
          category = "Cloud";
        };
      };

      element = when "s" {
        enable = true;
        subdomain = "element";
        exposure = "tunnel";
        port = 11341;
        homepage = {
          name = "Element";
          description = "Element web UI";
          icon = "element.svg";
          category = "Communication";
        };
      };

      continuwuity = when "s" {
        enable = true;
        subdomain = "matrix";
        exposure = "tunnel";
        port = 6167;
        homepage = {
          name = "Continuwuity";
          description = "Continuwuity homeserver";
          icon = "matrix.svg";
          category = "Communication";
        };
      };

      miniflux = when "s" {
        enable = true;
        subdomain = "feed";
        exposure = "local";
        port = 8087;
        homepage = {
          name = "Miniflux";
          description = "A minimalist and opinionated feed reader";
          icon = "miniflux.svg";
          category = "Communication";
        };
      };

      nextcloud = {
        enable = false;
        subdomain = "cloud";
        exposure = "local";
        port = 8182;
        homepage = {
          name = "Nextcloud";
          description = "A safe home for all your data";
          icon = "nextcloud.svg";
          category = "Cloud";
        };
      };

      qbittorrent = when "s" {
        enable = true;
        subdomain = "qbt";
        exposure = "local";
        port = 8081;
        homepage = {
          name = "qBittorrent";
          description = "Torrent client";
          icon = "qbittorrent.svg";
          category = "Downloads";
        };
      };

      qui = when "s" {
        enable = true;
        subdomain = "qui";
        exposure = "local";
        port = 7476;
        homepage = {
          name = "qui";
          description = "A web interface for qBittorrent";
          icon = "qui.svg";
          category = "Downloads";
        };
      };

      home-assistant = when "s" {
        enable = true;
        subdomain = "ha";
        exposure = "local";
        port = 8123;
        homepage = {
          name = "Home Assistant";
          description = "Awaken your home";
          icon = "home-assistant.svg";
          category = "Automation";
        };
      };

      slskd = {
        enable = false;
        subdomain = "slskd";
        exposure = "local";
        port = 5030;
        homepage = {
          name = "Soulseek";
          description = "Web-based Soulseek client";
          icon = "slskd.svg";
          category = "Downloads";
        };
      };

      tdarr = when "s" {
        enable = true;
        subdomain = "tdarr";
        exposure = "local";
        port = 8265;
        homepage = {
          name = "Tdarr";
          description = "Media transcoding application";
          icon = "tdarr.webp";
          category = "Media";
        };
      };

      turnstone = {
        enable = false;
        subdomain = "ts";
        exposure = "tailscale";
        port = 8098;
        homepage = {
          name = "Turnstone";
          description = "Multi-node AI orchestration platform";
          # icon = "turnstone.svg";
          category = "Automation";
        };
      };

      pihole = when "sz" {
        enable = true;
        subdomain = "pihole";
        exposure = "local";
        port = 8053;
        homepage = {
          name = "PiHole";
          description = "Adblocking and DNS service";
          icon = "pi-hole.svg";
          path = "/admin";
          category = "Infra";
        };
      };
    };
  };
}
