{config, ...}: {
  server = {
    enable = true;
    email = "adam@cnst.dev";
    domain = "cnix.dev";
    user = "share";
    group = "share";
    uid = 994;
    gid = 993;

    gitea = {
      enable = true;
    };
    unbound = {
      enable = true;
    };
    caddy = {
      enable = true;
    };
    homepage-dashboard = {
      enable = true;
    };
    bazarr = {
      enable = true;
    };
    prowlarr = {
      enable = true;
    };
    lidarr = {
      enable = true;
    };
    sonarr = {
      enable = true;
    };
    radarr = {
      enable = true;
    };
    jellyseerr = {
      enable = true;
    };
    jellyfin = {
      enable = true;
    };
    uptime-kuma = {
      enable = true;
    };
    keycloak = {
      enable = true;
      url = "login.cnst.dev";
      dbPasswordFile = config.age.secrets.keycloakDbPasswordFile.path;
      cloudflared = {
        tunnelId = "590f60f8-baaa-4106-b2d1-43740c79531e";
        credentialsFile = config.age.secrets.keycloakCloudflared.path;
      };
    };
    vaultwarden = {
      enable = true;
      url = "vault.cnst.dev";
      cloudflared = {
        tunnelId = "fdd98086-6a4c-44f2-bba0-eb86b833cce5";
        credentialsFile = config.age.secrets.vaultwardenCloudflared.path;
      };
    };
    ocis = {
      enable = true;
      url = "cloud.cnst.dev";
      cloudflared = {
        tunnelId = "8871dad0-e6ff-424c-9a6b-222ef0f492df";
        credentialsFile = config.age.secrets.ocisCloudflared.path;
      };
    };
    fail2ban = {
      enable = true;
      apiKeyFile = config.age.secrets.cloudflareFirewallApiKey.path;
      zoneId = "0027acdfb8bbe010f55b676ad8698dfb";
    };
    syncthing = {
      enable = false;
    };
    keepalived = {
      enable = true;
      interface = "enp6s0";
    };
    podman = {
      enable = true;
      gluetun.enable = true;
      qbittorrent = {
        enable = true;
        port = 8080;
      };
      slskd = {
        enable = true;
      };
      pihole = {
        enable = true;
        port = 8053;
      };
    };
  };
}
