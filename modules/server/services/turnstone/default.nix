{
  config,
  lib,
  self,
  pkgs,
  ...
}:
with lib;
let
  unit = "turnstone";
  srv = config.server;
  cfg = config.server.services.${unit};
  tsImage = "localhost/turnstone:latest";
in
{
  config = mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      turnstoneEnvironment.file = "${self}/secrets/turnstoneEnvironment.age";
    };

    system.activationScripts.turnstone-dirs = ''
      mkdir -p -m 0777 ${cfg.configDir}/{data,redis}
    '';

    systemd.services = {
      "podman-network-turnstone-net" = {
        path = [ pkgs.podman ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = "podman network rm -f turnstone-net";
        };
        script = ''
          podman network inspect turnstone-net || podman network create turnstone-net
        '';
        partOf = [ "podman-compose-turnstone-root.target" ];
        wantedBy = [ "podman-compose-turnstone-root.target" ];
      };

      "podman-turnstone-redis" = {
        serviceConfig = {
          Restart = lib.mkOverride 90 "always";
          RestartMaxDelaySec = lib.mkOverride 90 "1m";
          RestartSec = lib.mkOverride 90 "100ms";
          RestartSteps = lib.mkOverride 90 9;
        };
        after = [ "podman-network-turnstone-net.service" ];
        requires = [ "podman-network-turnstone-net.service" ];
        partOf = [ "podman-compose-turnstone-root.target" ];
        wantedBy = [ "podman-compose-turnstone-root.target" ];
      };

      "podman-turnstone-server" = {
        serviceConfig = {
          Restart = lib.mkOverride 90 "always";
          RestartMaxDelaySec = lib.mkOverride 90 "1m";
          RestartSec = lib.mkOverride 90 "100ms";
          RestartSteps = lib.mkOverride 90 9;
        };
        after = [
          "podman-network-turnstone-net.service"
          "podman-turnstone-redis.service"
        ];
        requires = [
          "podman-network-turnstone-net.service"
          "podman-turnstone-redis.service"
        ];
        partOf = [ "podman-compose-turnstone-root.target" ];
        wantedBy = [ "podman-compose-turnstone-root.target" ];
      };

      "podman-turnstone-bridge" = {
        serviceConfig = {
          Restart = lib.mkOverride 90 "always";
          RestartMaxDelaySec = lib.mkOverride 90 "1m";
          RestartSec = lib.mkOverride 90 "100ms";
          RestartSteps = lib.mkOverride 90 9;
        };
        after = [
          "podman-network-turnstone-net.service"
          "podman-turnstone-server.service"
          "podman-turnstone-redis.service"
        ];
        requires = [
          "podman-network-turnstone-net.service"
          "podman-turnstone-server.service"
          "podman-turnstone-redis.service"
        ];
        partOf = [ "podman-compose-turnstone-root.target" ];
        wantedBy = [ "podman-compose-turnstone-root.target" ];
      };

      "podman-turnstone-console" = {
        serviceConfig = {
          Restart = lib.mkOverride 90 "always";
          RestartMaxDelaySec = lib.mkOverride 90 "1m";
          RestartSec = lib.mkOverride 90 "100ms";
          RestartSteps = lib.mkOverride 90 9;
        };
        after = [
          "podman-network-turnstone-net.service"
          "podman-turnstone-redis.service"
        ];
        requires = [
          "podman-network-turnstone-net.service"
          "podman-turnstone-redis.service"
        ];
        partOf = [ "podman-compose-turnstone-root.target" ];
        wantedBy = [ "podman-compose-turnstone-root.target" ];
      };

      "podman-compose-turnstone-root" = {
        unitConfig.Description = "Root target for Turnstone podman stack";
        wantedBy = [ "multi-user.target" ];
      };
    };

    virtualisation.oci-containers.containers = {

      turnstone-redis = {
        image = "redis:7.4-alpine";
        ports = [ "127.0.0.1:36379:6379" ];
        cmd = [
          "sh"
          "-c"
          "redis-server --save 60 1 --loglevel warning \${REDIS_PASSWORD:+--requirepass \$REDIS_PASSWORD}"
        ];
        volumes = [
          "${cfg.configDir}/redis:/data"
        ];
        environmentFiles = [ config.age.secrets.turnstoneEnvironment.path ];
        extraOptions = [
          "--health-cmd=redis-cli ping | grep -q PONG"
          "--health-interval=5s"
          "--health-timeout=3s"
          "--health-retries=5"
          "--network-alias=redis"
          "--network=turnstone-net"
        ];
      };

      turnstone-server = {
        image = tsImage;
        cmd = [
          "sh"
          "-c"
          ''
            turnstone-server \
              --host 0.0.0.0 \
              --port ${toString cfg.port} \
              --base-url "$LLM_BASE_URL" \
              --api-key "$OPENAI_API_KEY" \
              ''${MODEL:+--model $MODEL} \
              ''${SKIP_PERMISSIONS:+--skip-permissions}
          ''
        ];
        ports = [ "127.0.0.1:${toString cfg.port}:${toString cfg.port}" ];
        volumes = [
          "${cfg.configDir}/data:/data"
        ];
        environment = {
          REDIS_PORT = "6379";
          TURNSTONE_DB_BACKEND = "sqlite";
        };
        environmentFiles = [ config.age.secrets.turnstoneEnvironment.path ];
        dependsOn = [ "turnstone-redis" ];
        extraOptions = [
          "--health-cmd=python /usr/local/bin/healthcheck.py http://127.0.0.1:${toString cfg.port}/health"
          "--health-interval=10s"
          "--health-timeout=5s"
          "--health-retries=3"
          "--network-alias=server"
          "--network=turnstone-net"
        ];
      };

      turnstone-bridge = {
        image = tsImage;
        cmd = [
          "turnstone-bridge"
          "--server-url=http://server:${toString cfg.port}"
          "--redis-host=redis"
          "--redis-port=36379"
          "--heartbeat-ttl=60"
          "--approval-timeout=3600"
        ];
        environment = {
          REDIS_PORT = "6379";
          TURNSTONE_DB_BACKEND = "sqlite";
        };
        environmentFiles = [ config.age.secrets.turnstoneEnvironment.path ];
        dependsOn = [
          "turnstone-server"
          "turnstone-redis"
        ];
        extraOptions = [
          "--network-alias=bridge"
          "--network=turnstone-net"
        ];
      };

      turnstone-console = {
        image = tsImage;
        cmd = [
          "turnstone-console"
          "--host=0.0.0.0"
          "--port=8099"
          "--redis-host=redis"
          "--poll-interval=10"
        ];
        ports = [ "127.0.0.1:8099:8099" ];
        environment = {
          REDIS_PORT = "6379";
          TURNSTONE_DB_BACKEND = "sqlite";
        };
        environmentFiles = [ config.age.secrets.turnstoneEnvironment.path ];
        dependsOn = [ "turnstone-redis" ];
        extraOptions = [
          "--health-cmd=python /usr/local/bin/healthcheck.py http://127.0.0.1:8099/health"
          "--health-interval=10s"
          "--health-timeout=5s"
          "--health-retries=3"
          "--network-alias=console"
          "--network=turnstone-net"
        ];
      };
    };
  };
}
