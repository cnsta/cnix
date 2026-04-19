{ config, ... }:
{
  server = {
    enable = true;
    email = "adam@cnst.dev";
    domain = "cnix.dev";
    ip = "192.168.88.14";
    user = "share";
    group = "share";
    uid = 994;
    gid = 993;

    infra = {
      cnixpost = {
        enable = false;
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

      authentik = {
        enable = true;
        url = "auth.cnst.dev";
        port = 9000;
        cloudflared = {
          tunnelId = "b66f9368-db9e-4302-8b48-527cda34a635";
          credentialsFile = config.age.secrets.authentikCloudflared.path;
        };
      };

      traefik = {
        enable = true;
      };

      tailscale = {
        enable = true;
      };

      unbound = {
        enable = true;
      };

      fail2ban = {
        enable = true;
        apiKeyFile = config.age.secrets.cloudflareFirewallApiKey.path;
        zoneId = "0027acdfb8bbe010f55b676ad8698dfb";
      };

      keepalived = {
        enable = true;
        interface = "enp6s0";
      };

      gluetun = {
        enable = true;
      };

      podman = {
        enable = true;
      };

      www = {
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
      homepage = {
        enable = true;
        subdomain = "dash";
        exposure = "local";
        port = 8082;
      };
      arr = {
        enable = true;
        routed = false;
      };
      authelia = {
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
      cinny = {
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
      memos = {
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
        enable = true;
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
      bazarr = {
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
      prowlarr = {
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
      flaresolverr = {
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
      grafana = {
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
      immich = {
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
      lidarr = {
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
      sonarr = {
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
      radarr = {
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
      roundcube = {
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
      seerr = {
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
      jellyfin = {
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
      uptime-kuma = {
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
      lldap = {
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
      forgejo = {
        enable = true;
        subdomain = "git";
        exposure = "tailscale";
        port = 3031;
        homepage = {
          name = "Forgejo";
          description = "A painless, self-hosted Git service";
          icon = "forgejo.svg";
          category = "Dev";
        };
      };
      vaultwarden = {
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
      element = {
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
      continuwuity = {
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
      qbittorrent = {
        enable = true;
        subdomain = "qbt";
        exposure = "local";
        port = 8080;
        homepage = {
          name = "qBittorrent";
          description = "Torrent client";
          icon = "qbittorrent.svg";
          category = "Downloads";
        };
      };
      home-assistant = {
        enable = false;
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
        enable = true;
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
      tdarr = {
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
      pihole = {
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
