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
    };
  };
}
