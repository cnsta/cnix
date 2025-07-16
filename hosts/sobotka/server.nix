{config, ...}: {
  server = {
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
    vaultwarden = {
      enable = true;
      url = "vault.cnst.dev";
      cloudflared = {
        tunnelId = "c3f541cb-b97e-4766-ae16-a8d863a3eec8";
        credentialsFile = config.age.secrets.vaultwardenCloudflared.path;
      };
    };
  };
}
