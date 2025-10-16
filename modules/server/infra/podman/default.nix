{
  config,
  lib,
  self,
  ...
}: let
  infra = config.server.infra;
  cfg = config.server.services;

  getPiholeSecret = hostname:
    if hostname == "ziggy"
    then [config.age.secrets.piholeZiggy.path]
    else if hostname == "sobotka"
    then [config.age.secrets.pihole.path]
    else throw "Unknown hostname: ${hostname}";
in {
  options.server.infra = {
    podman.enable = lib.mkEnableOption "Enables Podman";
    gluetun.enable = lib.mkEnableOption "Enables gluetun";
  };
  config = lib.mkIf infra.podman.enable {
    age.secrets = {
      pihole.file = "${self}/secrets/${config.networking.hostName}Pihole.age";
      slskd.file = "${self}/secrets/slskd.age";
    };

    virtualisation = {
      containers.enable = true;
      podman.enable = true;
    };

    networking.firewall = lib.mkIf cfg.pihole.enable {
      allowedTCPPorts = [
        53
        5335
      ];
      allowedUDPPorts = [
        53
        5335
      ];
    };

    virtualisation.oci-containers.containers = lib.mkMerge [
      (lib.mkIf infra.gluetun.enable {
        gluetun = {
          image = "qmcgaw/gluetun";
          ports = [
            "8388:8388"
            "58846:58846"
            "8080:8080"
            "5030:5030"
            "5031:5031"
            "50300:50300"
          ];
          devices = ["/dev/net/tun:/dev/net/tun"];
          autoStart = true;
          extraOptions = [
            "--cap-add=NET_ADMIN"
          ];
          volumes = ["/var:/gluetun"];
          environmentFiles = [
            config.age.secrets.gluetunEnvironment.path
          ];
          environment = {
            DEV_MODE = "false";
            VPN_SERVICE_PROVIDER = "mullvad";
            VPN_TYPE = "wireguard";
            SERVER_CITIES = "Stockholm";
          };
        };
      })

      (lib.mkIf cfg.qbittorrent.enable {
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
            "/mnt/data/media/downloads:/downloads:rw"
          ];
          environmentFiles = [
            config.age.secrets.gluetunEnvironment.path
          ];
          environment = {
            PUID = "994";
            PGID = "993";
            TZ = "Europe/Stockholm";
            WEBUI_PORT = "${builtins.toString cfg.qbittorrent.port}";
          };
        };
      })

      (lib.mkIf cfg.slskd.enable {
        slskd = {
          image = "slskd/slskd:latest";
          autoStart = true;
          dependsOn = ["gluetun"];
          ports = [
            "5030:5030"
            "5031:5031"
            "50300:50300"
          ];
          extraOptions = [
            "--network=container:gluetun"
          ];
          volumes = [
            "/var/lib/slskd:/app:rw"
            "/mnt/data/media/downloads:/downloads:rw"
          ];
          environmentFiles = [
            config.age.secrets.gluetunEnvironment.path
            config.age.secrets.slskd.path
          ];
          environment = {
            TZ = "Europe/Stockholm";
            PUID = "981";
            PGID = "982";
            SLSKD_REMOTE_CONFIGURATION = "true";
            SLSKD_REMOTE_FILE_MANAGEMENT = "true";
            SLSKD_DOWNLOADS_DIR = "/downloads";
            SLSKD_UMASK = "022";
          };
        };
      })

      (lib.mkIf cfg.pihole.enable {
        pihole = {
          autoStart = true;
          image = "pihole/pihole:2025.08.0";
          volumes = [
            "/var/lib/pihole:/etc/pihole/"
            "/var/lib/dnsmasq.d:/etc/dnsmasq.d/"
          ];
          environment = {
            TZ = "Europe/Stockholm";
            CUSTOM_CACHE_SIZE = "0";
            WEBTHEME = "default-darker";
          };
          environmentFiles = getPiholeSecret config.networking.hostName;
          ports = [
            "53:53/tcp"
            "53:53/udp"
            "8053:80/tcp"
          ];
          extraOptions = [
            "--cap-add=NET_ADMIN"
            "--cap-add=SYS_NICE"
            "--cap-add=SYS_TIME"
          ];
        };
      })
      (lib.mkIf cfg.ollama.enable {
        intel-llm = {
          autoStart = true;
          image = "intelanalytics/ipex-llm-inference-cpp-xpu:latest";
          devices = [
            "/dev/dri:/dev/dri:rwm"
          ];
          volumes = [
            "/var/lib/ollama:/models"
          ];
          environment = {
            OLLAMA_ORIGINS = "http://192.168.*";
            SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS = "1";
            ONEAPI_DEVICE_SELECTOR = "level_zero:0";
            OLLAMA_HOST = "[::]:11434";
            no_proxy = "localhost,127.0.0.1";
            DEVICE = "Arc";
            OLLAMA_NUM_GPU = "999";
            ZES_ENABLE_SYSMAN = "1";
          };
          cmd = [
            "/bin/sh"
            "-c"
            "/llm/scripts/start-ollama.sh && echo 'Startup script finished, container is now idling.' && sleep infinity"
          ];
          extraOptions = [
            "--net=host"
            "--memory=32G"
            "--shm-size=16g"
          ];
        };
      })
    ];
  };
}
