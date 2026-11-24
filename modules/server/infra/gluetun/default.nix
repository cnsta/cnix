{
  config,
  lib,
  self,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.cnix.server.infra.gluetun;
  srv = config.cnix.server;

  # Enabled services routed through each instance (services.<x>.vpn).
  membersOf = name: lib.filterAttrs (_: s: s.enable && s.vpn == name) srv.services;
  active = lib.filterAttrs (name: _: membersOf name != {}) cfg.instances;

  # agenix secret per instance: secrets/gluetun<Name>Environment.age
  secretName = name: "gluetun${lib.toUpper (lib.substring 0 1 name)}${lib.substring 1 (-1) name}Environment";

  mkGluetun = name: inst: {
    image = "ghcr.io/qdm12/gluetun:latest";
    pull = "newer";
    ports =
      lib.optional (inst.controlPort != null) "127.0.0.1:${toString inst.controlPort}:8000/tcp"
      ++ lib.mapAttrsToList (_: s: "127.0.0.1:${toString s.port}:${toString s.port}") (membersOf name)
      ++ inst.extraPorts;
    devices = ["/dev/net/tun:/dev/net/tun"];
    autoStart = true;
    extraOptions =
      ["--cap-add=NET_ADMIN" "--cap-add=NET_RAW"]
      ++ lib.optionals inst.disableIpv6 [
        "--sysctl=net.ipv6.conf.all.disable_ipv6=1"
        "--sysctl=net.ipv6.conf.default.disable_ipv6=1"
      ]
      ++ lib.optional (inst.ip != null) "--ip=${inst.ip}"
      ++ map (peer: "--add-host=gluetun-${peer}:${cfg.instances.${peer}.ip}") inst.peers
      ++ ["--label=io.containers.autoupdate=registry"]
      ++ inst.extraOptions;
    volumes = ["/var/lib/gluetun-${name}:/gluetun"];
    environmentFiles = [config.age.secrets.${secretName name}.path];
    environment.DEV_MODE = "false";
  };
in {
  options.cnix.server.infra.gluetun = {
    enable = lib.mkEnableOption "gluetun VPN containers";
    instances = mkOption {
      default = {};
      description = ''
        One gluetun container (`gluetun-<name>`) per entry. An instance runs only
        while some enabled service sets `vpn = "<name>"`; those services join its
        network namespace and get their `port` published on 127.0.0.1.
      '';
      type = types.attrsOf (types.submodule {
        options = {
          ip = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Fixed podman address, for instances other containers reach by name.";
          };
          controlPort = mkOption {
            type = types.nullOr types.port;
            default = null;
            description = "Publish gluetun's control server (:8000) on this loopback port.";
          };
          peers = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Other instances (with an `ip`) resolvable as gluetun-<peer> from inside this one.";
          };
          disableIpv6 = mkOption {
            type = types.bool;
            default = false;
          };
          extraPorts = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Port mappings besides the members' HTTP ports.";
          };
          extraOptions = mkOption {
            type = types.listOf types.str;
            default = [];
          };
        };
      });
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =
      lib.mapAttrsToList (n: s: {
        assertion = s.vpn == null || cfg.instances ? ${s.vpn};
        message = "cnix.server.services.${n}.vpn = \"${s.vpn}\" has no cnix.server.infra.gluetun.instances.${s.vpn}.";
      })
      srv.services
      ++ lib.concatLists (lib.mapAttrsToList (n: inst:
        map (peer: {
          assertion = (cfg.instances.${peer} or {ip = null;}).ip != null;
          message = "gluetun instance ${n}: peer ${peer} needs an ip.";
        })
        inst.peers)
      cfg.instances);

    age.secrets = lib.mapAttrs' (name: _:
      lib.nameValuePair (secretName name) {file = self + "/secrets/${secretName name}.age";})
    active;

    virtualisation.oci-containers.containers =
      lib.mapAttrs' (name: inst: lib.nameValuePair "gluetun-${name}" (mkGluetun name inst)) active;
  };
}
