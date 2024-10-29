{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.nixos.hardware.network;
in {
  options = {
    nixos.hardware.network = {
      enable = mkEnableOption "Enable the custom networking module";
      interfaces = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            allowedTCPPorts = mkOption {
              type = types.listOf types.int;
              default = [];
              description = "List of allowed TCP ports for this interface.";
            };
            allowedUDPPorts = mkOption {
              type = types.listOf types.int;
              default = [];
              description = "List of allowed UDP ports for this interface.";
            };
          };
        });
        default = {};
        description = "Network interface configurations.";
      };
      nm-applet = {
        enable = mkEnableOption "Enables the nm-applet service.";
        indicator = mkOption {
          type = types.bool;
          default = false;
          description = "Enables the nm-applet indicator.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.interfaces != {} -> config.networking.networkmanager.enable;
        message = "Network interfaces configured but NetworkManager is not enabled";
      }
    ];

    networking = {
      networkmanager.enable = true;
      nftables.enable = true;
      firewall = {
        enable = true;
        inherit (cfg) interfaces;
      };
    };

    systemd.services.NetworkManager = {
      wants = ["nftables.service"];
      after = ["nftables.service"];
    };

    programs.nm-applet = {
      enable = cfg.nm-applet.enable;
      indicator = cfg.nm-applet.indicator;
    };
  };
}
