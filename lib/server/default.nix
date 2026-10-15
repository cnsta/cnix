{lib}: let
  publicExposures = [
    "tunnel"
    "dedicated-tunnel"
    "public"
  ];

  server = {
    mkDomain = config: service: let
      inherit (config.cnix.settings.accounts.domains) local public;
    in
      if lib.elem service.exposure (publicExposures ++ ["tailscale"])
      then public
      else local;

    mkFullDomain = config: service: "${service.subdomain}.${server.mkDomain config service}";

    mkHostDomain = server.mkDomain;
  };
in {
  inherit server;
}
