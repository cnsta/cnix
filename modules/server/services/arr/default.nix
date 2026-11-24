{
  config,
  clib,
  lib,
  self,
  ...
}: let
  srv = config.cnix.server;

  # hotio images that share one shape: config in cfg.configDir, media at /data,
  # PUID/PGID of the shared user, network namespace of their gluetun instance.
  apps = {
    bazarr = {};
    prowlarr.media = false;
    qbittorrent = {
      secret = "qbtEnvironment";
      extraOptions = ["--requires=gluetun-qbt"];
    };
    radarr = {};
    sabnzbd = {};
    sonarr = {};
  };

  appDefaults = {
    media = true;
    secret = null;
    extraOptions = [];
  };

  enabled = lib.filterAttrs (name: _: srv.services.${name}.enable) apps;

  secretOf = name: app:
    if app.secret != null
    then app.secret
    else "${name}Environment";

  mkApp = name: app': let
    app = appDefaults // app';
    cfg = srv.services.${name};
    gluetun = "gluetun-${cfg.vpn}";
  in {
    secrets.${secretOf name app}.file = self + "/secrets/${secretOf name app}.age";
    tmpfiles = ["d ${cfg.configDir} 0755 ${srv.user} ${srv.group} - -"];
    container = {
      image = "ghcr.io/hotio/${name}:latest";
      autoStart = true;
      dependsOn = [gluetun];
      extraOptions = ["--network=container:${gluetun}"] ++ app.extraOptions;
      volumes = ["${cfg.configDir}:/config"] ++ lib.optional app.media "${srv.mediaDir}:/data";
      environmentFiles = [config.age.secrets.${secretOf name app}.path];
      environment = {inherit (clib.server.containerEnv config) PUID PGID;};
    };
  };

  built = lib.mapAttrs mkApp enabled;
in {
  config = lib.mkIf srv.infra.podman.enable {
    assertions =
      lib.mapAttrsToList (name: _: {
        assertion = srv.services.${name}.vpn != null;
        message = "cnix.server.services.${name} runs inside a gluetun namespace; set its `vpn`.";
      })
      enabled;

    age.secrets = lib.mkMerge (lib.mapAttrsToList (_: b: b.secrets) built);
    systemd.tmpfiles.rules = lib.concatLists (lib.mapAttrsToList (_: b: b.tmpfiles) built);
    virtualisation.oci-containers.containers = lib.mapAttrs (_: b: b.container) built;
  };
}
