{
  config,
  lib,
  self,
  pkgs,
  ...
}:
with lib; let
  cfg = config.cnix.server.infra.tailscale;
  iface = builtins.head (builtins.attrNames config.cnix.settings.network.interfaces);
in {
  options.cnix.server.infra.tailscale = {
    enable = mkEnableOption "Enable tailscale server configuration";
  };
  config = mkIf cfg.enable {
    age.secrets.hsPreauth.file = "${self}/secrets/hsPreauth.age";

    environment.systemPackages = [pkgs.ethtool];

    boot.initrd.systemd.network.wait-online.enable = false;

    networking.firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [config.services.tailscale.port];
    };

    systemd = {
      network.wait-online.enable = false;
      services = {
        tailscaled.serviceConfig.Environment = [
          "TS_DEBUG_FIREWALL_MODE=nftables"
        ];

        tailscaled-autoconnect = {
          after = [
            "headscale.service"
            "traefik.service"
          ];
          wants = ["headscale.service"];
        };

        tailscale-udp-gro = {
          wantedBy = ["multi-user.target"];
          after = ["network.target"];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.ethtool}/bin/ethtool -K ${iface} rx-udp-gro-forwarding on rx-gro-list off";
          };
        };
      };
    };

    services = {
      tailscale = {
        enable = true;
        openFirewall = true;
        useRoutingFeatures = "server";
        authKeyFile = config.age.secrets.hsPreauth.path;
        extraUpFlags = [
          "--login-server=https://hs.cnst.dev"
          "--accept-dns=false"
        ];
        extraSetFlags = [
          "--advertise-exit-node"
        ];
      };
    };
  };
}
