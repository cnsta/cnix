{
  lib,
  config,
  self,
  ...
}:
let
  unit = "keepalived";
  cfg = config.server.${unit};

  hostCfg =
    hostname:
    if hostname == "sobotka" then
      {
        ip = "192.168.88.14";
        priority = 20;
        state = "MASTER";
      }
    else if hostname == "ziggy" then
      {
        ip = "192.168.88.12";
        priority = 10;
        state = "BACKUP";
      }
    else
      throw "No keepalived config defined for host ${hostname}";

  _self = hostCfg config.networking.hostName;

  allPeers = [
    "192.168.88.12"
    "192.168.88.14"
  ];

  # Remove self from peers
  peers = builtins.filter (ip: ip != _self.ip) allPeers;
in
{
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    interface = lib.mkOption {
      type = lib.types.str;
      example = "eth0";
      description = "The network interface keepalived should bind to.";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.keepalived.file = "${self}/secrets/keepalived.age";
    services.keepalived = {
      enable = true;
      vrrpInstances.VI = {
        state = _self.state;
        interface = cfg.interface;
        virtualRouterId = 69;
        priority = _self.priority;
        unicastSrcIp = _self.ip;
        unicastPeers = peers;
        virtualIps = [
          {
            addr = "10.2.1.69/24";
          }
        ];
        extraConfig = ''
          authentication {
            auth_type PASS
            auth_pass ${config.age.secrets.keepalived.path}
          }
        '';
      };
    };
  };
}
