{
  config,
  lib,
  self,
  ...
}:
let
  unit = "pihole";
  srv = config.server;
  cfg = config.server.services.${unit};

  getPiholeSecret =
    hostname:
    if hostname == "ziggy" then
      [ config.age.secrets.piholeZiggy.path ]
    else if hostname == "sobotka" then
      [ config.age.secrets.pihole.path ]
    else
      throw "Unknown hostname: ${hostname}";
in
{
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      pihole.file = "${self}/secrets/${config.networking.hostName}Pihole.age";
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
        image = "pihole/pihole:2025.11.1";
        volumes = [
          "/var/lib/pihole:/etc/pihole/"
          "/var/lib/dnsmasq.d:/etc/dnsmasq.d/"
        ];
        environment = {
          TZ = "Europe/Stockholm";
          CUSTOM_CACHE_SIZE = "0";
          WEBTHEME = "default-darker";
        };
        environmentFiles = getPiholeSecret config.networking.hostName;
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
