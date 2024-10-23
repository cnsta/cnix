{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.nixos.hardware.network;
in {
  options = {
    nixos = {
      hardware = {
        network = {
          enable = mkEnableOption "Enable the custom networking module";

          hostName = mkOption {
            type = types.str;
            default = "default-hostname";
            description = "Hostname for the nixos.";
          };

          interfaces = mkOption {
            type = types.attrsOf (types.submodule {
              options = {
                allowedTCPPorts = mkOption {
                  type = types.listOf types.int;
                  default = [];
                  description = "List of allowed TCP ports for this interface.";
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
    };
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      inherit (cfg) hostName;
      nftables.enable = true;
      firewall = {
        enable = true;
        inherit (cfg) interfaces;
      };
    };
    programs.nm-applet = {
      enable = cfg.nm-applet.enable;
      indicator = cfg.nm-applet.indicator;
    };
  };
}
