{
  config,
  lib,
  inputs,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkMerge;
  cfg = config.modules.utils.agenix;
in {
  options = {
    modules.utils.agenix = {
      enable = mkEnableOption "Enables agenix system environment";
      cnix.enable = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Apply cnix agenix settings";
      };
      toothpc.enable = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Apply toothpc agenix settings";
      };
      cnixpad.enable = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Apply cnixpad agenix settings";
      };
    };
  };

  config = mkIf cfg.enable {
    age = mkMerge [
      (mkIf cfg.cnix.enable {
        secrets = {
          cnstssh.file = "${self}/secrets/cnstssh.age";
          cnixssh.file = "${self}/secrets/cnixssh.age";
          helix-gpt = {
            file = "${self}/secrets/helix-gpt.age";
            owner = "cnst";
            group = "users";
          };
        };
      })
      (mkIf cfg.toothpc.enable {
        secrets = {
          # Add toothpc specific secrets here
        };
      })
      (mkIf cfg.cnixpad.enable {
        secrets = {
          # Add adampad specific secrets here
        };
      })
    ];

    environment.systemPackages = [
      inputs.agenix.packages.x86_64-linux.default
      pkgs.age
    ];
  };
}
