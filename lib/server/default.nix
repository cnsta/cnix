{lib}: let
  publicExposures = [
    "tunnel"
    "dedicated-tunnel"
    "public"
  ];

  server = rec {
    # Domain a service lives on: public for anything reachable off-LAN
    # (tunnels, public, tailnet), local otherwise.
    mkDomain = config: service: let
      inherit (config.cnix.settings.site.domains) local public;
    in
      if lib.elem service.exposure (publicExposures ++ ["tailscale"])
      then public
      else local;

    mkFullDomain = config: service: "${service.subdomain}.${mkDomain config service}";

    mkUrl = config: service: "https://${mkFullDomain config service}";

    # Authelia on the same domain as `service`: Authelia serves both domains
    # (one session cookie each), and a client stays on its own domain.
    autheliaUrl = config: service: "https://${config.cnix.server.services.authelia.subdomain}.${mkDomain config service}";

    # Services that get a Traefik router, DNS records and tailnet names.
    routable = config:
      lib.filterAttrs
      (_: s: s.enable && s.routed && s.subdomain != "")
      config.cnix.server.services;

    # Extra names served besides each service's own: `localAlias` services
    # also answer on the local domain, plus the Traefik dashboard.
    localAliases = config: let
      srv = config.cnix.server;
      local = config.cnix.settings.site.domains.local;
    in
      lib.optional srv.infra.traefik.enable "${srv.infra.traefik.subdomain}.${local}"
      ++ lib.mapAttrsToList (_: s: "${s.subdomain}.${local}")
      (lib.filterAttrs (_: s: s.localAlias) (routable config));

    # Where a Cloudflare tunnel sends a service: its Anubis gate if it has one.
    tunnelTarget = service: "http://127.0.0.1:${toString (
      if service.anubis.port != null
      then service.anubis.port
      else service.port
    )}";

    # PUID/PGID/TZ for linuxserver/hotio-style images, as the shared user.
    containerEnv = config: let
      srv = config.cnix.server;
    in {
      PUID = toString config.users.users.${srv.user}.uid;
      PGID = toString config.users.groups.${srv.group}.gid;
      TZ = srv.timeZone;
    };

    # "cnix.dev" -> "dc=cnix,dc=dev"
    ldapBaseDn = domain: lib.concatMapStringsSep "," (dc: "dc=" + dc) (lib.splitString "." domain);
  };
in {
  inherit server;
}
