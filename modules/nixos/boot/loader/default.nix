{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge mkForce;
  cfg = config.nixos.boot.loader;
in {
  options = {
    nixos.boot.loader = {
      default = {
        enable = mkEnableOption "Enable default boot loader configuration.";
      };
      lanzaboote = {
        enable = mkEnableOption "Enable Lanzaboote boot loader configuration.";
      };
    };
  };

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  config = mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.default.enable && cfg.lanzaboote.enable);
          message = "Only one of nixos.boot.loader.default.enable and nixos.boot.loader.lanzaboote.enable can be set to true.";
        }
      ];
    }

    (mkIf cfg.default.enable {
      # Default boot loader configuration
      boot.loader = {
        systemd-boot.enable = true;
        systemd-boot.graceful = true;
        efi.canTouchEfiVariables = false;
      };
    })

    (mkIf cfg.lanzaboote.enable {
      # Lanzaboote boot loader configuration
      boot = {
        lanzaboote = {
          enable = true;
          pkiBundle = "/etc/secureboot";
        };

        # We let Lanzaboote install systemd-boot
        loader.systemd-boot.enable = mkForce false;
      };

      environment.systemPackages = [pkgs.sbctl];
    })
  ];
}
