{
  config,
  lib,
  self,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.server.infra.tailscale;
in
{
  options.server.infra.tailscale = {
    enable = mkEnableOption "Enable tailscale server configuration";
  };
  config = mkIf cfg.enable {
    age.secrets.sobotkaTsAuth.file = "${self}/secrets/sobotkaTsAuth.age";

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
        authKeyFile = config.age.secrets.sobotkaTsAuth.path;
        extraSetFlags = [
          "--advertise-exit-node"
        ];
      };

      networkd-dispatcher = {
        enable = true;
        rules."50-tailscale-optimizations" = {
          onState = [ "routable" ];
          script = ''
            ${pkgs.ethtool}/bin/ethtool -K enp6s0 rx-udp-gro-forwarding on rx-gro-list off
          '';
        };
      };
    };
  };
}
