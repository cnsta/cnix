{
  config,
  lib,
  self,
  ...
}: let
  unit = "pihole";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      pihole.file = self + "/secrets/${config.networking.hostName}Pihole.age";
    };

    networking.firewall = {
      allowedTCPPorts = [
        53
        5335
      ];
      allowedUDPPorts = [
        53
        5335
      ];
    };

    virtualisation.oci-containers.containers = {
      ${unit} = {
        autoStart = true;
        image = "docker.io/pihole/pihole:latest";
        volumes = [
          "/var/lib/pihole:/etc/pihole/"
          "/var/lib/dnsmasq.d:/etc/dnsmasq.d/"
        ];
        environment = {
          TZ = "Europe/Stockholm";
          CUSTOM_CACHE_SIZE = "0";
          WEBTHEME = "default-darker";
        };
        environmentFiles = [config.age.secrets.pihole.path];
        ports = [
          "53:53/tcp"
          "53:53/udp"
          "8053:80/tcp"
        ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=SYS_NICE"
          "--cap-add=SYS_TIME"
        ];
      };
    };
  };
}
