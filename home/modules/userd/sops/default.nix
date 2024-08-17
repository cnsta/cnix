{
  inputs,
  self,
  lib,
  config,
  ...
}: let
  defaultConfig = {
    age = {sshKeyPaths = ["/home/cnst/.ssh/id_ed25519"];};
    defaultSopsFile = "${self}/secrets/cnst-secrets.yaml";
    secrets = {
      openai_api_key = {
        format = "yaml";
        sopsFile = "${self}/secrets/cnst-secrets.yaml";
      };
      ssh_user = {
        format = "yaml";
        sopsFile = "${self}/secrets/cnst-secrets.yaml";
      };
    };
  };

  userSpecificConfig = lib.mkMerge [
    (lib.mkIf (config.home.username == "toothpick") {
      age = {sshKeyPaths = ["/home/toothpick/.ssh/id_ed25519"];};
      defaultSopsFile = "${self}/secrets/toothpick-secrets.yaml";
      secrets = {
        openai_api_key = {
          format = "yaml";
          sopsFile = "${self}/secrets/toothpick-secrets.yaml";
        };
        ssh_user = {
          format = "yaml";
          sopsFile = "${self}/secrets/toothpick-secrets.yaml";
        };
      };
    })
    (lib.mkIf (config.home.username == "adam") {
      age = {sshKeyPaths = ["/home/adam/.ssh/id_ed25519"];};
      defaultSopsFile = "${self}/secrets/adam-secrets.yaml";
      secrets = {
        openai_api_key = {
          format = "yaml";
          sopsFile = "${self}/secrets/adam-secrets.yaml";
        };
        ssh_user = {
          format = "yaml";
          sopsFile = "${self}/secrets/adam-secrets.yaml";
        };
      };
    })
  ];
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.userd.sops;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  options = {
    modules.userd.sops.enable = mkEnableOption "Enables sops home environment";
  };
  config = mkIf cfg.enable {
    sops = lib.mkMerge [
      {
        gnupg = {
          home = "~/.gnupg";
          sshKeyPaths = [];
        };
      }
      defaultConfig
      userSpecificConfig
    ];
  };
}
