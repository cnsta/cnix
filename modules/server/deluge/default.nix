{
  config,
  lib,
  ...
}: let
  cfg = config.server.deluge;
  url = "https://deluge.${config.server.domain}";
  port = 8112;
in {
  options.server.deluge = {
    enable = lib.mkEnableOption "Enable Deluge";
    url = lib.mkOption {
      type = lib.types.str;
      default = "deluge.${config.server.domain}";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Deluge";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Torrent client";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "deluge.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Downloads";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.server.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };

    virtualisation.podman.enable = true;

    virtualisation.oci-containers.containers = {
      deluge = {
        image = "linuxserver/deluge:latest";
        autoStart = true;
        dependsOn = ["gluetun"];
        ports = [
          "8112:8112"
          "58846:58846"
        ];
        extraOptions = [
          "--network=container:gluetun"
        ];
        volumes = [
          "config:/storage/volumes/config"
          "config:/storage/volumes/downloads"
        ];
        environmentFiles = [
          config.age.secrets.gluetunEnv.path
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Etc/UTC";
        };
      };

      gluetun = {
        image = "qmcgaw/gluetun";
        ports = [
          "8388:8388"
          "58846:58846"
          "8112:8112"
        ];
        devices = ["/dev/net/tun:/dev/net/tun"];
        autoStart = true;
        extraOptions = [
          "--cap-add=NET_ADMIN"
        ];
        volumes = ["/var:/gluetun"];
        environmentFiles = [
          config.age.secrets.gluetunEnv.path
        ];
        environment = {
          DEV_MODE = "false";
          VPN_SERVICE_PROVIDER = "mullvad";
          VPN_TYPE = "wireguard";
          SERVER_CITIES = "Stockholm";
        };
      };
    };
  };
}
