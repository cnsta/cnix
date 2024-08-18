{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.modules.sysd.sops;
in {
  options = {
    modules.sysd.sops = {
      enable = mkEnableOption "Enables sops system environment";
      cnix = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Apply cnix sops settings";
      };
      toothpc = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Apply toothpc sops settings";
      };
      adampad = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Apply adampad sops settings";
      };
    };
  };

  config = mkIf cfg.enable {
    sops = lib.mkMerge [
      {
        age = {sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];};
        gnupg = {
          home = "~/.gnupg";
          sshKeyPaths = [];
        };
      }
      (mkIf cfg.cnix {
        secrets = {
          openai_api_key = {
            format = "yaml";
            sopsFile = "${self}/secrets/cnix-secrets.yaml";
          };
          ssh_host = {
            format = "yaml";
            sopsFile = "${self}/secrets/cnix-secrets.yaml";
          };
        };
      })
      (mkIf cfg.toothpc {
        secrets = {
          openai_api_key = {
            format = "yaml";
            sopsFile = "${self}/secrets/toothpc-secrets.yaml";
          };
          ssh_host = {
            format = "yaml";
            sopsFile = "${self}/secrets/toothpc-secrets.yaml";
          };
        };
      })
      (mkIf cfg.adampad {
        secrets = {
          openai_api_key = {
            format = "yaml";
            sopsFile = "${self}/secrets/adampad-secrets.yaml";
          };
          ssh_host = {
            format = "yaml";
            sopsFile = "${self}/secrets/adampad-secrets.yaml";
          };
        };
      })
    ];

    environment.systemPackages = [
      pkgs.sops
      pkgs.age
    ];
  };
}
