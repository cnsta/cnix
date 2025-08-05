{
  config,
  lib,
  ...
}: let
  srv = config.server;
  cfg = config.server.podman;
in {
  options.server.podman = {
    enable = lib.mkEnableOption "Enables Podman";
    qbittorrent = {
      enable = lib.mkEnableOption "Enable qBittorrent";
      url = lib.mkOption {
        type = lib.types.str;
        default = "qbt.${srv.domain}";
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

    slskd = {
      enable = lib.mkEnableOption "Enable Soulseek";
      url = lib.mkOption {
        type = lib.types.str;
        default = "slskd.${srv.domain}";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 5030;
        description = "The port to host Soulseek webui on.";
      };
      homepage.name = lib.mkOption {
        type = lib.types.str;
        default = "slskd";
      };
      homepage.description = lib.mkOption {
        type = lib.types.str;
        default = "Web-based Soulseek client";
      };
      homepage.icon = lib.mkOption {
        type = lib.types.str;
        default = "slskd.svg";
      };
      homepage.category = lib.mkOption {
        type = lib.types.str;
        default = "Downloads";
      };
    };

    pihole = {
      enable = lib.mkEnableOption {
        description = "Enable";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 8053;
        description = "The port to host PiHole on.";
      };
      url = lib.mkOption {
        type = lib.types.str;
        default = "pihole.${srv.domain}";
      };
      homepage.name = lib.mkOption {
        type = lib.types.str;
        default = "PiHole";
      };
      homepage.description = lib.mkOption {
        type = lib.types.str;
        default = "Adblocking and DNS service";
      };
      homepage.icon = lib.mkOption {
        type = lib.types.str;
        default = "pi-hole.svg";
      };
      homepage.category = lib.mkOption {
        type = lib.types.str;
        default = "Services";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;
      podman.enable = true;
    };

    networking.firewall = lib.mkIf cfg.pihole.enable {
      allowedTCPPorts = [53 5335];
      allowedUDPPorts = [53 5335];
    };

    services.caddy.virtualHosts = lib.mkMerge [
      (lib.mkIf cfg.qbittorrent.enable {
        "${cfg.qbittorrent.url}" = {
          useACMEHost = srv.domain;
          extraConfig = ''
            reverse_proxy http://127.0.0.1:${toString cfg.qbittorrent.port}
          '';
        };
      })

      (lib.mkIf cfg.slskd.enable {
        "${cfg.slskd.url}" = {
          useACMEHost = srv.domain;
          extraConfig = ''
            reverse_proxy http://127.0.0.1:${toString cfg.slskd.port}
          '';
        };
      })

      (lib.mkIf cfg.pihole.enable {
        "${cfg.pihole.url}" = {
          useACMEHost = srv.domain;
          extraConfig = ''
            reverse_proxy http://127.0.0.1:${toString cfg.pihole.port}
          '';
        };
      })
    ];

    virtualisation.oci-containers.containers = lib.mkMerge [
      (lib.mkIf cfg.enable {
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
            config.age.secrets.gluetunEnv.path
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
            "/share/downloads:/downloads:rw"
          ];
          environmentFiles = [
            config.age.secrets.gluetunEnv.path
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
            "/share/downloads:/downloads:rw"
          ];
          environmentFiles = [
            config.age.secrets.gluetunEnv.path
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
          image = "pihole/pihole:latest";
          volumes = [
            "/var/lib/pihole:/etc/pihole/"
            "/var/lib/dnsmasq.d:/etc/dnsmasq.d/"
          ];
          environment = {
            TZ = "Europe/Stockholm";
            CUSTOM_CACHE_SIZE = "0";
            # PIHOLE_DNS_ = "10.88.0.1#5335";
            # DNSSEC = "false";
            # REV_SERVER = "true";
            WEBTHEME = "default-darker";
          };
          environmentFiles = [config.age.secrets.pihole.path];
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
    ];
  };
}
