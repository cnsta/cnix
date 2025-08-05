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
          cloudflareFirewallApiKey.file = "${self}/secrets/cloudflareFirewallApiKey.age";
          cloudflareDnsApiToken.file = "${self}/secrets/cloudflareDnsApiToken.age";
          cloudflareDnsCredentials.file = "${self}/secrets/cloudflareDnsCredentials.age";
          wgCredentials.file = "${self}/secrets/wgCredentials.age";
          wgSobotkaPrivateKey.file = "${self}/secrets/wgSobotkaPrivateKey.age";
          gluetunEnv.file = "${self}/secrets/gluetunEnv.age";
          vaultwardenCloudflared.file = "${self}/secrets/vaultwardenCloudflared.age";
          vaultwarden-env.file = "${self}/secrets/vaultwarden-env.age";
          homepage-env.file = "${self}/secrets/homepage-env.age";
          pihole.file = "${self}/secrets/pihole.age";
          slskd.file = "${self}/secrets/slskd.age";
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
