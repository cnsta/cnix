{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.network;
in {
  options = {
    modules = {
      network = {
        enable = mkEnableOption "Enable the custom networking module";

        hostName = mkOption {
          type = types.str;
          default = "default-hostname";
          description = "Hostname for the system.";
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
  };
}
