{
  lib,
  config,
  hosts,
  self,
  ...
}: let
  unit = "keepalived";
  cfg = config.cnix.server.infra.${unit};

  selfIp = config.cnix.settings.network.localIp;
  peers = map (h: hosts.${h}.ip) (lib.filter (h: h != config.networking.hostName) cfg.members);

  hasCheck = cfg.healthCheck != null;
in {
  options.cnix.server.infra.${unit} = {
    enable = lib.mkEnableOption "Enable ${unit}";
    members = lib.mkOption {
      type = lib.types.listOf (lib.types.enum (lib.attrNames hosts));
      description = "Hosts (hosts/registry.nix names, each with an `ip`) sharing the VIP.";
    };
    priority = lib.mkOption {
      type = lib.types.ints.between 1 254;
      description = "VRRP priority; the highest healthy member holds the VIP.";
    };
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

    users.users.keepalived_script = {
      isSystemUser = true;
      group = "keepalived_script";
      description = "keepalived health-check script user";
    };
    users.groups.keepalived_script = {};

    services.keepalived = {
      enable = true;
      enableScriptSecurity = true;
      extraGlobalDefs = "max_auto_priority";
      secretFile = config.age.secrets.keepalived.path;

      vrrpScripts = lib.optionalAttrs hasCheck {
        chk_service = {
          script = cfg.healthCheck;
          interval = 5;
          timeout = 4;
          rise = 2;
          fall = 3;
          weight = -15;
        };
      };

      vrrpInstances.VI = {
        state = "BACKUP";
        interface = cfg.interface;
        virtualRouterId = 69;
        inherit (cfg) priority;
        unicastSrcIp = selfIp;
        unicastPeers = peers;
        virtualIps = [{addr = "${config.cnix.settings.site.dnsVip}/24";}];
        trackScripts = lib.optionals hasCheck ["chk_service"];
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
