{config, ...}: {
  server = {
    enable = true;
    email = "adam@cnst.dev";
    domain = "cnst.dev";
    caddy = {
      enable = true;
    };
    fail2ban = {
      enable = true;
      apiKeyFile = config.age.secrets.cloudflareFirewallApiKey.path;
      zoneId = "0027acdfb8bbe010f55b676ad8698dfb";
    };
    homepage = {
      enable = true;
    };
    prowlarr = {
      enable = true;
    };
    lidarr = {
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
      port = 8090;
    };
  };
}
