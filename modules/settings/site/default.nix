{lib, ...}: let
  inherit (lib) mkOption types;
  str = description:
    mkOption {
      inherit description;
      type = types.str;
    };
in {
  # Network-wide constants shared by every host. Values are set once, in
  # modules/settings/modules.nix; modules read them, never restate them.
  options.cnix.settings.site = {
    domains = {
      local = str "LAN/tailnet-only domain (Traefik + unbound records for local services).";
      public = str "Public domain (tunnels, public and tailnet services, www).";
    };
    mail = str "Admin mail address (ACME, alerts).";
    router = str "LAN gateway; also the NTP server.";
    dnsVip = str "keepalived virtual IP that LAN clients use as DNS.";
    loginServer = str "Headscale URL tailnet clients log in to.";
    subnets = {
      lan = str "LAN IPv4 CIDR.";
      podman = str "Podman default bridge CIDR (`podman network inspect podman`).";
      tailnet4 = str "Headscale IPv4 prefix.";
      tailnet6 = str "Headscale IPv6 prefix.";
    };
  };
}
