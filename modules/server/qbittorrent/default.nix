{
  config,
  lib,
  ...
}: let
  cfg = config.server.qbittorrent;
in {
  options.server.qbittorrent = {
    enable = lib.mkEnableOption "Enable qBittorrent";
    url = lib.mkOption {
      type = lib.types.str;
      default = "qbt.${config.server.domain}";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8080;
      description = "The port to host qBittorrent on.";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "qBittorrent";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Torrent client";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "qbittorrent.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Downloads";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = config.server.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };

    virtualisation.podman.enable = true;

    virtualisation.oci-containers.containers = {
      qbittorrent = {
        image = "ghcr.io/hotio/qbittorrent:latest";
        autoStart = true;
        dependsOn = ["gluetun"];
        ports = [
          "8080:8080"
          "58846:58846"
        ];
        extraOptions = [
          "--network=container:gluetun"
        ];
        volumes = [
          "/var/lib/qbittorrent:/config:rw"
          "/share/downloads:/downloads:rw"
        ];
        environmentFiles = [
          config.age.secrets.gluetunEnv.path
        ];
        environment = {
          PUID = "994";
          PGID = "993";
          TZ = "Europe/Stockholm";
          WEBUI_PORT = "${builtins.toString cfg.port}";
        };
      };

      gluetun = {
        image = "qmcgaw/gluetun";
        ports = [
          "8388:8388"
          "58846:58846"
          "8080:8080"
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
