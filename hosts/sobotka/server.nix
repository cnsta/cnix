{config, ...}: {
  server = {
    enable = true;
    email = "adam@cnst.dev";
    domain = "cnst.dev";
    user = "share";
    group = "share";
    uid = 994;
    gid = 993;

    pihole = {
      enable = true;
    };
    unbound = {
      enable = false;
    };
    caddy = {
      enable = true;
    };
    fail2ban = {
      enable = true;
      apiKeyFile = config.age.secrets.cloudflareFirewallApiKey.path;
      zoneId = "0027acdfb8bbe010f55b676ad8698dfb";
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
    vaultwarden = {
      enable = true;
      url = "vault.cnst.dev";
      cloudflared = {
        tunnelId = "fdd98086-6a4c-44f2-bba0-eb86b833cce5";
        credentialsFile = config.age.secrets.vaultwardenCloudflared.path;
      };
    };
    qbittorrent = {
      enable = true;
      port = 8080;
    };
  };
}
