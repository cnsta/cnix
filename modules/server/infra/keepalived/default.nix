{
  lib,
  config,
  self,
  ...
}:
let
  unit = "keepalived";
  cfg = config.cnix.server.infra.${unit};

  hostCfg =
    hostname:
    if hostname == "sobotka" then
      {
        ip = "192.168.88.14";
        priority = 20;
      }
    else if hostname == "ziggy" then
      {
        ip = "192.168.88.12";
        priority = 10;
      }
    else
      throw "No keepalived config defined for host ${hostname}";

  _self = hostCfg config.networking.hostName;

  allPeers = [
    "192.168.88.12"
    "192.168.88.14"
  ];
  peers = builtins.filter (ip: ip != _self.ip) allPeers;

  hasCheck = cfg.healthCheck != null;
in
{
  options.cnix.server.infra.${unit} = {
    enable = lib.mkEnableOption "Enable ${unit}";
    interface = lib.mkOption {
      type = lib.types.str;
      example = "eth0";
      description = "The network interface keepalived should bind to.";
    };
    healthCheck = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/run/current-system/sw/bin/systemctl is-active --quiet traefik.service";
      description = ''
        Command run periodically to decide whether this node should keep the
        virtual IP. A non-zero exit drops this node's VRRP priority below the
        peer's, handing the VIP over. Must be a single command, no shell pipes.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.keepalived.file = "${self}/secrets/keepalived.age";

    services.keepalived = {
      enable = true;
      secretFile = config.age.secrets.keepalived.path;

      vrrpScripts = lib.optionalAttrs hasCheck {
        chk_service = {
          script = cfg.healthCheck;
          interval = 2;
          timeout = 3;
          rise = 2;
          fall = 2;
          weight = -20;
        };
      };

      vrrpInstances.VI = {
        state = "BACKUP";
        interface = cfg.interface;
        virtualRouterId = 69;
        priority = _self.priority;
        unicastSrcIp = _self.ip;
        unicastPeers = peers;
        virtualIps = [ { addr = "192.168.88.69/24"; } ];
        trackScripts = lib.optionals hasCheck [ "chk_service" ];
        extraConfig = ''
          garp_master_refresh 5
          authentication {
            auth_type PASS
            auth_pass ''${KEEPALIVED_AUTH_PASS}
          }
        '';
      };
    };
  };
}
