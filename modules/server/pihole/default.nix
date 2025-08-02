{
  config,
  lib,
  ...
}: let
  unit = "pihole";
  srv = config.server;
  cfg = config.server.${unit};
in {
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "${unit}.${srv.domain}";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "PiHole";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Adblocking and DNS service";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "pi-hole.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };
  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [53 5335];
      allowedUDPPorts = [53 5335];
    };

    services.unbound.settings.server = {
      access-control = ["10.88.0.0/24 allow"];
      port = "5335";
    };

    virtualisation.oci-containers = {
      backend = "podman";
      containers.pihole = {
        autoStart = true;
        image = "pihole/pihole:latest";
        volumes = ["/var/lib/pihole:/etc/pihole/"];
        environment = {
          TZ = "Europe/Stockholm";
          CUSTOM_CACHE_SIZE = "0";
          # PIHOLE_DNS_ = "10.88.0.1#5335";
          # DNSSEC = "false";
          # REV_SERVER = "true";
          WEBTHEME = "default-darker";
        };
        environmentFiles = [config.age.secrets.pihole.path];
        ports = [
          "192.168.88.14:53:53/tcp"
          "192.168.88.14:53:53/udp"
          "8053:80/tcp"
        ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=SYS_NICE"
          "--cap-add=SYS_TIME"
        ];
      };
    };

    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = srv.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:8053
      '';
    };
  };
}
