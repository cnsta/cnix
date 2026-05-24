{
  cnix.server = {
    enable = true;
    email = "adam@cnst.dev";
    domain = "ziggy.local";
    ip = "192.168.88.12";
    user = "share";
    group = "share";
    uid = 994;
    gid = 993;

    infra = {
      traefik.enable = true;
      unbound.enable = true;
      podman.enable = true;
      keepalived = {
        enable = true;
        interface = "enu1u1";
      };
    };
    services = {
      pihole = {
        enable = true;
        subdomain = "pihole";
        exposure = "local";
        port = 8053;
        homepage = {
          name = "PiHole";
          description = "Adblocking and DNS service";
          icon = "pi-hole.svg";
          path = "/admin";
          category = "Infra";
        };
      };
    };
  };
}
