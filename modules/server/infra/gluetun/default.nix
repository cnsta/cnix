{
  config,
  lib,
  self,
  ...
}:
let
  infra = config.server.infra;
  cfg = config.server.services;
  arr = config.server.services.arr;
in
{
  options.server.infra = {
    gluetun.enable = lib.mkEnableOption "Enables gluetun";
  };
  config = lib.mkIf infra.gluetun.enable {
    age.secrets = {
      gluetunEnvironment.file = (self + "/secrets/gluetunEnvironment.age");
      gluetunSearxngEnvironment.file = (self + "/secrets/gluetunSearxngEnvironment.age");
      gluetunArrEnvironment.file = (self + "/secrets/gluetunArrEnvironment.age");
    };

    virtualisation.oci-containers.containers = {
      gluetun = {
        image = "ghcr.io/qdm12/gluetun:latest";
        ports = [
          "8388:8388"
          "58846:58846"
          "8080:8080"
          "5030:5030"
          "5031:5031"
          "50300:50300"
        ];
        devices = [ "/dev/net/tun:/dev/net/tun" ];
        autoStart = true;
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
        ];
        volumes = [ "/var/lib/gluetun:/gluetun" ];
        environmentFiles = [
          config.age.secrets.gluetunEnvironment.path
        ];
        environment = {
          DEV_MODE = "false";
        };
      };

      gluetun-searxng = lib.mkIf cfg.searxng.enable {
        image = "ghcr.io/qdm12/gluetun:latest";
        ports = [
          "8084:8084"
        ];
        devices = [ "/dev/net/tun:/dev/net/tun" ];
        autoStart = true;
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
        ];
        volumes = [ "/var/lib/gluetun-searxng:/gluetun" ];
        environmentFiles = [
          config.age.secrets.gluetunSearxngEnvironment.path
        ];
        environment = {
          DEV_MODE = "false";
        };
      };

      gluetun-arr = lib.mkIf arr.enable {
        image = "ghcr.io/qdm12/gluetun:latest";
        ports = [
          "8191:8191"
          "9696:9696"
          "8989:8989"
          "7878:7878"
          "8686:8686"
        ];
        devices = [ "/dev/net/tun:/dev/net/tun" ];
        autoStart = true;
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
          "--sysctl=net.ipv6.conf.all.disable_ipv6=1"
          "--sysctl=net.ipv6.conf.default.disable_ipv6=1"
        ];
        volumes = [ "/var/lib/gluetun-arr:/gluetun" ];
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
