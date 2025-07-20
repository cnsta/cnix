{
  config,
  lib,
  pkgs,
  ...
}: let
  srv = config.server;
  cfg = config.server.deluge;
  ns = config.server.wireguard-netns.namespace;
in {
  options.server.deluge = {
    enable = lib.mkEnableOption "Deluge torrent client (bound to a Wireguard VPN network)";
    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/deluge";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "deluge.${srv.domain}";
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
    services.deluge = {
      enable = true;
      user = srv.user;
      group = srv.group;
      web.enable = true;
    };

    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = srv.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:8112
      '';
    };

    systemd = lib.mkIf srv.wireguard-netns.enable {
      services.deluged = {
        bindsTo = ["netns@${ns}.service"];
        requires = ["network-online.target"];
        serviceConfig.NetworkNamespacePath = "/var/run/netns/${ns}";
      };

      sockets."delugedproxy" = {
        enable = true;
        description = "Socket for Proxy to Deluge WebUI";
        listenStreams = ["58846"];
        wantedBy = ["sockets.target"];
      };

      services."delugedproxy" = {
        description = "Proxy to Deluge in Network Namespace";
        requires = [
          "deluged.service"
          "delugedproxy.socket"
        ];
        after = [
          "deluged.service"
          "delugedproxy.socket"
        ];
        unitConfig = {
          JoinsNamespaceOf = "deluged.service";
        };
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:58846";
          PrivateNetwork = true;
          NetworkNamespacePath = "/var/run/netns/${ns}";
        };
      };
    };
  };
}
