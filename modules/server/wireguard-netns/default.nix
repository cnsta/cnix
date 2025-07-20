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
    privateIP = lib.mkOption {
      type = lib.types.str;
    };
    dnsIP = lib.mkOption {
      type = lib.types.str;
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services."netns@" = {
      description = "%I network namespace";
      before = ["network.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
        ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
      };
    };
    environment.etc."netns/${cfg.namespace}/resolv.conf".text = "nameserver ${cfg.dnsIP}";

    systemd.services.${cfg.namespace} = {
      description = "${cfg.namespace} network interface";
      bindsTo = ["netns@${cfg.namespace}.service"];
      requires = ["network-online.target"];
      after = ["netns@${cfg.namespace}.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = with pkgs;
          writers.writeBash "wg-up" ''
            set -e
            ${iproute2}/bin/ip link add wg1 type wireguard
            ${iproute2}/bin/ip link set wg1 netns ${cfg.namespace}
            ${iproute2}/bin/ip -n ${cfg.namespace} address add ${cfg.privateIP} dev wg1
            ${iproute2}/bin/ip netns exec ${cfg.namespace} \
            ${wireguard-tools}/bin/wg setconf wg1 ${cfg.configFile}
            ${iproute2}/bin/ip -n ${cfg.namespace} link set wg1 up
            ${iproute2}/bin/ip -n ${cfg.namespace} link set lo up
            ${iproute2}/bin/ip -n ${cfg.namespace} route add default dev wg1
          '';
        ExecStop = with pkgs;
          writers.writeBash "wg-down" ''
            set -e
            ${iproute2}/bin/ip -n ${cfg.namespace} route del default dev wg1
            ${iproute2}/bin/ip -n ${cfg.namespace} link del wg1
          '';
      };
    };
  };
}
