{config, ...}: {
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
      homepage-dashboard = {
        enable = true;
        subdomain = "dash";
        exposure = "local";
        port = 8082;
      };
      n8n = {
        enable = true;
        subdomain = "n8n";
        exposure = "local";
        port = 5678;
        homepage = {
          name = "n8n";
          description = "A workflow automation platform";
          icon = "n8n.svg";
          category = "Services";
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
          category = "Arr";
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
          category = "Arr";
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
          category = "Arr";
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
          category = "Arr";
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
          category = "Arr";
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
          category = "Arr";
        };
      };
      jellyseerr = {
        enable = true;
        subdomain = "jellyseerr";
        exposure = "local";
        port = 5055;
        homepage = {
          name = "Jellyseerr";
          description = "Media request and discovery manager";
          icon = "jellyseerr.svg";
          category = "Arr";
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
          category = "Services";
        };
      };
      gitea = {
        enable = true;
        subdomain = "git";
        exposure = "tunnel";
        port = 5003;
        cloudflared = {
          tunnelId = "33e2fb8e-ecef-4d42-b845-6d15e216e448";
          credentialsFile = config.age.secrets.giteaCloudflared.path;
        };
        homepage = {
          name = "Gitea";
          description = "Git with a cup of tea";
          icon = "gitea.svg";
          category = "Services";
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
          category = "Services";
        };
      };
      nextcloud = {
        enable = true;
        subdomain = "cloud";
        exposure = "local";
        port = 8182;
        homepage = {
          name = "Nextcloud";
          description = "A safe home for all your data";
          icon = "nextcloud.svg";
          category = "Services";
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
      pihole = {
        enable = true;
        subdomain = "pihole";
        exposure = "local";
        port = 8053;
        homepage = {
          name = "PiHole";
          description = "Adblocking and DNS service";
          icon = "pi-hole.svg";
          category = "Services";
          path = "/admin";
        };
      };
    };
  };
}
