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
      services.deluged.serviceConfig.NetworkNamespacePath = "/var/run/netns/${ns}";

      services.deluged.after = [
        "netns@${ns}.service"
        "network-online.target"
      ];

      sockets."delugedproxy" = {
        enable = true;
        description = "Socket Proxy for Deluge WebUI";
        listenStreams = [
          "127.0.0.1:8112"
        ];
        wantedBy = ["sockets.target"];
      };

      services."delugedproxy" = {
        description = "Proxy to Deluge in Network Namespace";
        requires = ["deluged.service"];
        after = ["delugedproxy.socket"];
        unitConfig = {
          JoinsNamespaceOf = "deluged.service";
        };

        serviceConfig = {
          Type = "simple";
          ExecStart = ''
            ${pkgs.socat}/bin/socat - TCP4:127.0.0.1:8112
          '';
          PrivateNetwork = true;
          NetworkNamespacePath = "/var/run/netns/${ns}";
        };
      };
    };
  };
}
