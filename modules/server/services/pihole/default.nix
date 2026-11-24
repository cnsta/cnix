{
  config,
  lib,
  self,
  ...
}: let
  unit = "pihole";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
  unbound = config.cnix.server.infra.unbound;
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      pihole.file = self + "/secrets/${config.networking.hostName}Pihole.age";
    };

    networking.firewall = {
      allowedTCPPorts = [53 unbound.listenPort];
      allowedUDPPorts = [53 unbound.listenPort];
    };

    virtualisation.oci-containers.containers = {
      ${unit} = {
        autoStart = true;
        image = "docker.io/pihole/pihole:latest";
        volumes = [
          "${cfg.configDir}:/etc/pihole/"
          "/var/lib/dnsmasq.d:/etc/dnsmasq.d/"
        ];
        environment = {
          TZ = config.cnix.server.timeZone;
          CUSTOM_CACHE_SIZE = "0";
          WEBTHEME = "default-darker";
        };
        environmentFiles = [config.age.secrets.pihole.path];
        ports = [
          "53:53/tcp"
          "53:53/udp"
          "${lib.optionalString srv.infra.traefik.enable "127.0.0.1:"}${toString cfg.port}:80/tcp"
        ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=SYS_NICE"
          "--cap-add=SYS_TIME"
          "--cgroup-parent=system-dns.slice"
        ];
      };
    };
  };
}
