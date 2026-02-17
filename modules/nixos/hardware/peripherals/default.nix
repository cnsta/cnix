{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.hardware.peripherals;
in
{
  options = {
    nixos.hardware.peripherals = {
      logitech.enable = mkEnableOption "Enables support for wireless logitech devices";
      kanata.enable = mkEnableOption "Enables kanata and hhkb keymaps";
      adb.enable = mkEnableOption "Whether to configure system to use Android Debug Bridge";
      yubikey = {
        manager.enable = mkEnableOption "Enables yubikey manager";
        touch-detector.enable = mkEnableOption "Enables yubikey touch detector";
      };
      pcscd.enable = mkEnableOption "Enables pcscd";
      pulsar-x2 = {
        enable = mkEnableOption "Enables pulsar-x2-control";
        tray.enable = mkEnableOption "Enables tray module for pulsar-x2";
      };
      utils.enable = mkEnableOption "Miscellaneous utility packages";
    };
  };
  config = {
    hardware = {
      logitech.wireless = mkIf cfg.logitech.enable {
        enable = true;
        enableGraphical = true;
      };
      pulsar-x2 = mkIf cfg.pulsar-x2.enable {
        enable = true;
        tray = mkIf cfg.pulsar-x2.tray.enable {
          enable = true;
          threshold = 15;
          interval = 60;
        };
      };
    };
    services = {
      kanata = mkIf cfg.kanata.enable {
        enable = true;
        package = pkgs.kanata-with-cmd;
        keyboards.default = {
          extraDefCfg = ''
            process-unmapped-keys yes
          '';
          config = builtins.readFile (./. + "/hhkbse.kbd");
        };
      };
      pcscd.enable = mkIf cfg.pcscd.enable true;
    };
    programs = {
      yubikey-manager.enable = mkIf cfg.yubikey.manager.enable true;
      yubikey-touch-detector.enable = mkIf cfg.yubikey.touch-detector.enable true;
    };
    environment.systemPackages =
      with pkgs;
      lib.optionals cfg.utils.enable [
        usbutils
        usbimager
      ]
      ++ lib.optionals cfg.adb.enable [
        android-tools
      ];
  };
}
