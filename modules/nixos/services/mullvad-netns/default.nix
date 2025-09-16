{ self, pkgs, ... }:
{
  age.secrets.wgCredentials = {
    file = "${self}/secrets/wgCredentials.age";
    mode = "0400";
    owner = "root";
    group = "root";
    path = "/etc/wireguard/mullvad.conf";
  };

  systemd.services.mullvad-netns = {
    description = "WireGuard Mullvad netns for VMs";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStart = "${pkgs.writeShellScript "mullvad-netns-up" ''
        set -euo pipefail

        ip netns add mullvad || true

        ip link add veth0 type veth peer name veth1 || true
        ip link set veth1 netns mullvad
        ip addr add 10.250.0.1/24 dev veth0 || true
        ip link set veth0 up
        ip netns exec mullvad ip addr add 10.250.0.2/24 dev veth1 || true
        ip netns exec mullvad ip link set veth1 up

        ip netns exec mullvad wg-quick up /etc/wireguard/mullvad.conf
        ip netns exec mullvad ip route add default dev wg0 || true

        nft add table ip mullvad-nat || true
        nft add chain ip mullvad-nat postrouting { type nat hook postrouting priority 100 \; } || true
        nft add rule ip mullvad-nat postrouting ip saddr 10.250.0.0/24 oif "wg0" masquerade || true
      ''}";

      ExecStop = "${pkgs.writeShellScript "mullvad-netns-down" ''
        set -euo pipefail

        ip netns exec mullvad wg-quick down /etc/wireguard/mullvad.conf || true
        ip link delete veth0 || true
        ip netns delete mullvad || true
        nft delete table ip mullvad-nat || true
      ''}";
    };

    # no wantedBy here -> won't start at boot
  };
}
