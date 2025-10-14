{lib}: let
  server = {
    mkDomain = config: service: let
      localDomain = config.settings.accounts.domains.local;
      publicDomain = config.settings.accounts.domains.public;
      tailscaleDomain = "ts.${publicDomain}";
    in
      if service.exposure == "tunnel"
      then publicDomain
      else if service.exposure == "tailscale"
      then tailscaleDomain
      else localDomain;

    mkFullDomain = config: service: let
      domain = server.mkDomain config service;
    in "${service.subdomain}.${domain}";

    mkHostDomain = config: service: let
      domain = server.mkDomain config service;
    in "${domain}";

    mkSubDomain = config: service: "${service.subdomain}";
  };
in {
  server = server;
}
