{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  defaultConfig = {
    defaultSopsFile = "${self}/secrets/cnix-secrets.yaml";
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
  };

  hostSpecificConfig = lib.mkMerge [
    (lib.mkIf (config.networking.hostName == "toothpc") {
      defaultSopsFile = "${self}/secrets/toothpc-secrets.yaml";
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
    (lib.mkIf (config.networking.hostName == "adampad") {
      defaultSopsFile = "${self}/secrets/adampad-secrets.yaml";
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
in {
  sops = lib.mkMerge [
    {
      age = {sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];};
      gnupg = {
        home = "~/.gnupg";
        sshKeyPaths = [];
      };
    }
    defaultConfig
    hostSpecificConfig
  ];
  environment.systemPackages = [
    pkgs.sops
    pkgs.age
  ];
}
