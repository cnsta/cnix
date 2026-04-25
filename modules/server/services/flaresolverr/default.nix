{
  config,
  lib,
  self,
  ...
}:
let
  unit = "flaresolverr";
  srv = config.server;
  cfg = config.server.services.${unit};
  arr = config.server.services.arr;
in
{
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    age.secrets = {
      flaresolverrEnvironment = {
        file = (self + "/secrets/flaresolverrEnvironment.age");
        mode = "0444";
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/flaresolverr 0755 root root - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "flaresolverr/flaresolverr:latest";
        autoStart = true;
        dependsOn = [ "gluetun-arr" ];
        extraOptions = [
          "--network=container:gluetun-arr"
          "--sysctl=net.ipv6.conf.all.disable_ipv6=1"
          "--sysctl=net.ipv6.conf.default.disable_ipv6=1"
        ];
        volumes = [
          "/var/lib/flaresolverr:/config"
        ];
        environmentFiles = [ config.age.secrets.flaresolverrEnvironment.path ];
      };
    };
  };
}
