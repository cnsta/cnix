{
  config,
  lib,
  self,
  ...
}: let
  infra = config.cnix.server.infra;
  cfg = config.cnix.server.services;
  arr = config.cnix.server.services.arr;

  qbtIp = "10.88.0.250";
in {
  options.cnix.server.infra = {
    gluetun.enable = lib.mkEnableOption "Enables gluetun";
  };
  config = lib.mkIf infra.gluetun.enable {
    age.secrets = {
      gluetunQbtEnvironment.file = self + "/secrets/gluetunQbtEnvironment.age";
      gluetunDispatcharrEnvironment.file = self + "/secrets/gluetunDispatcharrEnvironment.age";
      gluetunSlskdEnvironment.file = self + "/secrets/gluetunSlskdEnvironment.age";
      gluetunArrEnvironment.file = self + "/secrets/gluetunArrEnvironment.age";
    };

    virtualisation.oci-containers.containers = {
      gluetun-qbt = lib.mkIf cfg.qbittorrent.enable {
        image = "ghcr.io/qdm12/gluetun:latest";
        pull = "newer";
        ports = [
          "127.0.0.1:8081:8081"
        ];
        devices = ["/dev/net/tun:/dev/net/tun"];
        autoStart = true;
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
          "--ip=${qbtIp}"
          "--label=io.containers.autoupdate=registry"
          "--health-cmd=wget -qO- https://ipinfo.io/ip || exit 1"
          "--health-interval=10s"
          "--health-retries=6"
          "--health-start-period=30s"
        ];
        volumes = ["/var/lib/gluetun-qbt:/gluetun"];
        environmentFiles = [
          config.age.secrets.gluetunQbtEnvironment.path
        ];
        environment = {
          DEV_MODE = "false";
        };
      };

      gluetun-dispatcharr = lib.mkIf cfg.dispatcharr.enable {
        image = "ghcr.io/qdm12/gluetun:latest";
        pull = "newer";
        ports = [
          "127.0.0.1:9191:9191"
        ];
        devices = ["/dev/net/tun:/dev/net/tun"];
        autoStart = true;
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
          "--label=io.containers.autoupdate=registry"
        ];
        volumes = ["/var/lib/gluetun-dispatcharr:/gluetun"];
        environmentFiles = [
          config.age.secrets.gluetunDispatcharrEnvironment.path
        ];
        environment = {
          DEV_MODE = "false";
        };
      };

      gluetun-slskd = lib.mkIf cfg.slskd.enable {
        image = "ghcr.io/qdm12/gluetun:latest";
        pull = "newer";
        ports = [
          "8388:8388"
          "127.0.0.1:5030:5030"
          "127.0.0.1:5031:5031"
          "50323:50323"
        ];
        devices = ["/dev/net/tun:/dev/net/tun"];
        autoStart = true;
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
          "--label=io.containers.autoupdate=registry"
        ];
        volumes = ["/var/lib/gluetun-slskd:/gluetun"];
        environmentFiles = [
          config.age.secrets.gluetunSlskdEnvironment.path
        ];
        environment = {
          DEV_MODE = "false";
        };
      };

      gluetun-arr = lib.mkIf arr.enable {
        image = "ghcr.io/qdm12/gluetun:latest";
        pull = "newer";
        ports = [
          "127.0.0.1:8003:8000/tcp"
          "127.0.0.1:8191:8191"
          "127.0.0.1:9696:9696"
          "127.0.0.1:8989:8989"
          "127.0.0.1:7878:7878"
          "127.0.0.1:8686:8686"
          "127.0.0.1:8687:8687"
          "127.0.0.1:7476:7476"
          "127.0.0.1:1867:1867"
          "127.0.0.1:8085:8085"
          "127.0.0.1:4533:4533"
        ];
        devices = ["/dev/net/tun:/dev/net/tun"];
        autoStart = true;
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
          "--sysctl=net.ipv6.conf.all.disable_ipv6=1"
          "--sysctl=net.ipv6.conf.default.disable_ipv6=1"
          "--add-host=gluetun-qbt:${qbtIp}"
          "--label=io.containers.autoupdate=registry"
        ];
        volumes = ["/var/lib/gluetun-arr:/gluetun"];
        environmentFiles = [
          config.age.secrets.gluetunArrEnvironment.path
        ];
        environment = {
          DEV_MODE = "false";
        };
      };
    };
  };
}
