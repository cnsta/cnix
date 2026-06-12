{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.cnix.settings.network;
in
{
  options = {
    cnix.settings.network = {
      enable = mkEnableOption "Enable the custom networking module";
      tailscale.enable = mkEnableOption "Enable tailscale client service";
      bluetooth.enable = mkEnableOption "Enables bluetooth";
      nameservers = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "The list of nameservers ";
      };
      search = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Domain search paths";
      };
      localIp = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The local IP of the service.";
      };
      interfaces = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              allowedTCPPorts = mkOption {
                type = types.listOf types.int;
                default = [ ];
                description = "List of allowed TCP ports for this interface.";
              };
              allowedUDPPorts = mkOption {
                type = types.listOf types.int;
                default = [ ];
                description = "List of allowed UDP ports for this interface.";
              };
            };
          }
        );
        default = { };
        description = "Network interface configurations.";
      };
      extraHosts = mkOption {
        type = types.lines;
        default = "";
        description = "Extra entries for /etc/hosts.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.interfaces != { } -> config.networking.networkmanager.enable;
        message = "Network interfaces configured but NetworkManager is not enabled";
      }
    ];

    networking = {
      networkmanager.enable = true;
      nftables.enable = true;
      nameservers = cfg.nameservers;
      search = cfg.search;
      firewall = {
        enable = true;
        inherit (cfg) interfaces;
      };
      extraHosts = cfg.extraHosts;
    };

    systemd.services.NetworkManager = {
      wants = [ "nftables.service" ];
      after = [ "nftables.service" ];
    };

    services.tailscale = mkIf cfg.tailscale.enable {
      enable = true;
      extraUpFlags = [ "--login-server=https://hs.cnst.dev" ];
      extraSetFlags = [ "--accept-routes" ];
    };

    hardware = mkIf cfg.bluetooth.enable {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    };
  };
}
