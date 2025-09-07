{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkMerge
    mkForce
    ;
  cfg = config.nixos.boot.loader;
in
{
  options = {
    nixos.boot.loader = {
      default = {
        enable = mkEnableOption "Enable default boot loader configuration.";
      };
      lanzaboote = {
        enable = mkEnableOption "Enable Lanzaboote boot loader configuration.";
      };
      extlinux = {
        enable = mkEnableOption "Enable extlinux boot loader configuration.";
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
          assertion =
            (lib.count (x: x) [
              cfg.default.enable
              cfg.lanzaboote.enable
              cfg.extlinux.enable
            ]) <= 1;
          message = "Only one of nixos.boot.loader.{default,lanzaboote,extlinux}.enable can be set to true.";
        }
      ];
    }

    (mkIf cfg.default.enable {
      boot.loader = {
        systemd-boot.enable = true;
        systemd-boot.graceful = true;
        efi.canTouchEfiVariables = false;
      };
    })

    (mkIf cfg.extlinux.enable {
      boot.loader = {
        generic-extlinux-compatible.enable = true;
        grub.enable = false;
      };
    })

    (mkIf cfg.lanzaboote.enable {
      boot = {
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
        loader.systemd-boot.enable = mkForce false;
      };
      environment.systemPackages = [ pkgs.sbctl ];
    })
  ];
}
