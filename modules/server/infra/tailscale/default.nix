{
  config,
  lib,
  self,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cnix.server.infra.tailscale;
  iface = builtins.head (builtins.attrNames config.cnix.settings.network.interfaces);
in
{
  options.cnix.server.infra.tailscale = {
    enable = mkEnableOption "Enable tailscale server configuration";
  };
  config = mkIf cfg.enable {
    age.secrets.tsAuth.file = "${self}/secrets/tsAuth.age";

    environment.systemPackages = [ pkgs.ethtool ];

    boot.initrd.systemd.network.wait-online.enable = false;

    networking.firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    systemd = {
      network.wait-online.enable = false;
      services.tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL_MODE=nftables"
      ];
    };

    services = {
      tailscale = {
        enable = true;
        openFirewall = true;
        useRoutingFeatures = "server";
        authKeyFile = config.age.secrets.tsAuth.path;
        extraSetFlags = [
          "--advertise-exit-node"
        ];
      };

      networkd-dispatcher = {
        enable = true;
        rules."50-tailscale-optimizations" = {
          onState = [ "routable" ];
          script = ''
            ${pkgs.ethtool}/bin/ethtool -K ${iface} rx-udp-gro-forwarding on rx-gro-list off
          '';
        };
      };
    };
  };
}
