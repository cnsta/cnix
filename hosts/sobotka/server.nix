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
        tunnelId = "3c5b96f8-9608-4d7d-9baa-ef24064ec4c1";
        credentialsFile = config.age.secrets.cloudflareDnsApiToken.path;
      };
    };
  };
}
