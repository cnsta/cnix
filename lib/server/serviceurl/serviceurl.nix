{config}: service: let
  mainDomain = config.server.networking.domain;
  tailscaleDomain = "ts.${mainDomain}";

  domain =
    if service.exposure == "tunnel"
    then mainDomain
    else if service.exposure == "tailscale"
    then tailscaleDomain
    else (service.domain or mainDomain);
in "${service.subdomain}.${domain}"
