{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.server.wireguard-netns;
in {
  options.server.wireguard-netns = {
    enable = lib.mkEnableOption "Enable a network namespace with WireGuard VPN";
    configFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the WireGuard configuration file (e.g., mullvad.conf)";
    };
    namespace = lib.mkOption {
      type = lib.types.str;
      default = "vpn";
      description = "Name of the network namespace";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      netnsSetup = pkgs.writeShellApplication {
        name = "netns-${cfg.namespace}-setup";
        runtimeInputs = with pkgs; [iproute2 wireguard-tools gawk coreutils];
        text = ''
          set -eux

          CONFIG=${cfg.configFile}
          NS=${cfg.namespace}
          ADDR=$(awk -F' *= *' '/^Address/ { print $2 }' "$CONFIG")
          DNS=$(awk -F' *= *' '/^DNS/ { print $2 }' "$CONFIG")

          ip netns delete "$NS" 2>/dev/null || true
          ip netns add "$NS"
          ip link add wg0 type wireguard
          ip link set wg0 netns "$NS"
          ip -n "$NS" addr add "$ADDR" dev wg0
          ip -n "$NS" link set wg0 up
          ip netns exec "$NS" wg setconf wg0 "$CONFIG"
          ip netns exec "$NS" ip link set lo up
          ip netns exec "$NS" ip route add default dev wg0

          mkdir -p /etc/netns/"$NS"
          echo "nameserver $DNS" > /etc/netns/"$NS"/resolv.conf
        '';
      };

      netnsTeardown = pkgs.writeShellApplication {
        name = "netns-${cfg.namespace}-teardown";
        runtimeInputs = with pkgs; [iproute2];
        text = ''
          set -eu
          ip netns delete ${cfg.namespace} || true
        '';
      };
    in {
      systemd.services."netns@${cfg.namespace}" = {
        description = "WireGuard VPN netns (${cfg.namespace})";
        after = ["network-online.target"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${netnsSetup}/bin/netns-${cfg.namespace}-setup";
          ExecStop = "${netnsTeardown}/bin/netns-${cfg.namespace}-teardown";
        };
      };
    }
  );
}
