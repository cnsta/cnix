{
  config,
  lib,
  self,
  ...
}: let
  unit = "flaresolverr";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
  gluetun = "gluetun-${cfg.vpn}";
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      flaresolverrEnvironment = {
        file = self + "/secrets/flaresolverrEnvironment.age";
        mode = "0444";
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.configDir} 0755 root root - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "docker.io/flaresolverr/flaresolverr:latest";
        autoStart = true;
        dependsOn = [gluetun];
        extraOptions = [
          "--network=container:${gluetun}"
          "--sysctl=net.ipv6.conf.all.disable_ipv6=1"
          "--sysctl=net.ipv6.conf.default.disable_ipv6=1"
        ];
        volumes = [
          "${cfg.configDir}:/config"
        ];
        environmentFiles = [config.age.secrets.flaresolverrEnvironment.path];
      };
    };
  };
}
