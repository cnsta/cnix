{
  config,
  lib,
  self,
  pkgs,
  ...
}:
let
  unit = "continuwuity";
  cfg = config.server.services.${unit};
  domain = config.server.infra.www.url;
in
{
  config = lib.mkIf cfg.enable {
    age.secrets = {
      continuwuityEnvironment = {
        file = (self + "/secrets/continuwuityEnvironment.age");
        mode = "0444";
      };
      continuwuityToml = {
        file = (self + "/secrets/continuwuityToml.age");
        mode = "0444";
      };
      livekitEnvironment = {
        file = (self + "/secrets/livekitEnvironment.age");
        mode = "0444";
      };
      livekitYaml = {
        file = (self + "/secrets/livekitYaml.age");
        mode = "0444";
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 7881 ];
      allowedUDPPortRanges = [
        {
          from = 50100;
          to = 50200;
        }
      ];
    };

    services.traefik.dynamicConfigOptions.http = {
      routers = {
        livekit = {
          entryPoints = [ "websecure" ];
          rule = "Host(`livekit.${domain}`)";
          service = "livekit";
          tls.certResolver = "letsencrypt";
        };
        livekit-jwt = {
          entryPoints = [ "websecure" ];
          rule = "Host(`livekit.${domain}`) && (PathPrefix(`/sfu/get`) || PathPrefix(`/healthz`) || PathPrefix(`/get_token`))";
          service = "livekit-jwt";
          tls.certResolver = "letsencrypt";
        };
      };
      services = {
        livekit.loadBalancer.servers = [
          { url = "http://127.0.0.1:7880"; }
        ];
        livekit-jwt.loadBalancer.servers = [
          { url = "http://127.0.0.1:8083"; }
        ];
      };
    };

    virtualisation.oci-containers.containers = {
      continuwuity = {
        autoStart = true;
        image = "forgejo.ellis.link/continuwuation/continuwuity:latest";
        volumes = [
          "db:/var/lib/continuwuity"
          "${config.age.secrets.continuwuityToml.path}:/etc/continuwuity.toml:ro"
        ];
        environmentFiles = [ config.age.secrets.continuwuityEnvironment.path ];
        extraOptions = [
          "--net=host"
          "--ulimit=nofile=1048567:1048567"
        ];
      };

      lk-jwt-service = {
        autoStart = true;
        image = "ghcr.io/element-hq/lk-jwt-service:latest";
        # dependsOn = [ "stoat-redis" ];
        ports = [
          "8083:8083"
        ];
        environmentFiles = [ config.age.secrets.livekitEnvironment.path ];
      };

      livekit = {
        autoStart = true;
        image = "livekit/livekit-server:latest";
        dependsOn = [ "lk-jwt-service" ];
        cmd = [
          "--config"
          "/etc/livekit.yaml"
        ];
        volumes = [ "${config.age.secrets.livekitYaml.path}:/etc/livekit.yaml:ro" ];
        extraOptions = [
          "--net=host"
        ];
      };
    };
    environment.systemPackages = [ pkgs.matrix-continuwuity ];
  };
}
