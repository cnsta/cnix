{
  config,
  lib,
  self,
  ...
}: let
  unit = "octo-fiesta";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};
  navidrome = config.cnix.server.services.navidrome;
  arr = config.cnix.server.services.arr;
  subsonicUrl = "http://host.containers.internal:${toString navidrome.port}";
in {
  config = lib.mkIf (srv.infra.podman.enable && arr.enable && cfg.enable) {
    age.secrets.octofiestaEnvironment.file = self + "/secrets/octofiestaEnvironment.age";

    systemd.tmpfiles.rules = [
      "d /mnt/data/media/music/octo-fiesta 0755 share share -"
    ];

    virtualisation.oci-containers.containers = {
      ${unit} = {
        image = "ghcr.io/v1ck3s/octo-fiesta:dev";
        autoStart = true;
        dependsOn = ["gluetun-arr"];
        extraOptions = [
          "--network=container:gluetun-arr"
        ];
        volumes = [
          "/mnt/data/media/music/octo-fiesta:/app/downloads"
        ];
        environmentFiles = [config.age.secrets.octofiestaEnvironment.path];
        environment = {
          ASPNETCORE_ENVIRONMENT = "Production";
          ASPNETCORE_URLS = "http://+:${toString cfg.port}";
          "Subsonic__Url" = subsonicUrl;
        };
      };
    };
  };
}
