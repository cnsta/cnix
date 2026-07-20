{
  config,
  lib,
  self,
  ...
}: let
  unit = "qbittorrent";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
  arr = config.cnix.server.services.arr;
in {
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    age.secrets = {
      qbtEnvironment.file = self + "/secrets/qbtEnvironment.age";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/qbittorrent 0755 share share - -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/hotio/qbittorrent:latest";
        autoStart = true;
        dependsOn = ["gluetun-qbt"];
        extraOptions = [
          "--network=container:gluetun-qbt"
          "--requires=gluetun-qbt"
        ];
        volumes = [
          "/var/lib/qbittorrent:/config:rw"
          "/mnt/data:/data:rw"
        ];
        environmentFiles = [config.age.secrets.qbtEnvironment.path];
      };
    };
  };
}
