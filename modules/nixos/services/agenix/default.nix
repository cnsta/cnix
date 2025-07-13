{
  config,
  lib,
  inputs,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkMerge;
  cfg = config.nixos.services.agenix;
in {
  options = {
    nixos.services.agenix = {
      enable = mkEnableOption "Enables agenix system environment";
      kima.enable = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Apply kima agenix settings";
      };
      bunk.enable = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Apply bunk agenix settings";
      };
      sobotka.enable = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Apply sobotka agenix settings";
      };
      toothpc.enable = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Apply toothpc agenix settings";
      };
    };
  };

  config = mkIf cfg.enable {
    age = mkMerge [
      (mkIf cfg.kima.enable {
        secrets = {
          cnstssh.file = "${self}/secrets/cnstssh.age";
          cnixssh.file = "${self}/secrets/cnixssh.age";
          certpem.file = "${self}/secrets/certpem.age";
          keypem.file = "${self}/secrets/keypem.age";
          mailpwd.file = "${self}/secrets/mailpwd.age";
          gcapi = {
            file = "${self}/secrets/gcapi.age";
            owner = "cnst";
          };
        };
      })
      (mkIf cfg.bunk.enable {
        secrets = {
          # Add bunk specific secrets here
        };
      })
      (mkIf cfg.sobotka.enable {
        secrets = {
          # Add sobotka specific secrets here
        };
      })
      (mkIf cfg.toothpc.enable {
        secrets = {
          # Add toothpc specific secrets here
        };
      })
    ];

    environment = {
      systemPackages = [
        inputs.agenix.packages.x86_64-linux.default
        pkgs.age
      ];
    };
  };
}
