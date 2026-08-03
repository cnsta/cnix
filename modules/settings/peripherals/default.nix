{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.options) mkEnableOption mkOption;
  cfg = config.cnix.settings.peripherals;
in {
  imports = [
    inputs.litecrazy.nixosModules.default
  ];
  options = {
    cnix.settings.peripherals = {
      logitech.enable = mkEnableOption "Enables support for wireless logitech devices";
      kanata.enable = mkEnableOption "Enables kanata and hhkb keymaps";
      adb.enable = mkEnableOption "Whether to configure system to use Android Debug Bridge";
      yubikey = {
        manager.enable = mkEnableOption "Enables yubikey manager";
        touch-detector.enable = mkEnableOption "Enables yubikey touch detector";
      };
      pcscd.enable = mkEnableOption "Enables pcscd";
      litecrazy = {
        enable = mkEnableOption "Enables litecrazy";
        service = {
          enable = mkEnableOption ''
            Systemd user service.

            Runs `litecrazy` in tray mode as a systemd user service, started
            automatically with your graphical session.

            Requires `hardware.litecrazy.enable = true`.
          '';
          browser = mkOption {
            type = types.nullOr (types.either types.package types.str);
            default = null;
            example = lib.literalExpression "pkgs.chromium";
            description = ''
              Browser used for the configurator. When null, litecrazy searches
              for a Chromium-based browser itself.

              The configurator drives the mouse over WebHID, which only
              Chromium-derived browsers implement — Firefox will load the page
              but never see the device.
            '';
          };
          batteryInterval = mkOption {
            type = types.ints.between 10 3600;
            default = 60;
            description = "Seconds between battery polls.";
          };
          lowBatteryThreshold = mkOption {
            type = types.ints.between 0 100;
            default = 20;
            description = "Battery percentage that triggers a notification. 0 disables them.";
          };
        };
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
      litecrazy = mkIf cfg.litecrazy.enable {
        enable = true;
        service = mkIf cfg.litecrazy.service.enable {
          enable = true;
          browser = cfg.litecrazy.service.browser;
          batteryInterval = cfg.litecrazy.service.batteryInterval;
          lowBatteryThreshold = cfg.litecrazy.service.lowBatteryThreshold;
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

            ;; Only grab the HHKB-Hybrid. Without this, kanata grabs every
            ;; keyboard-class HID device including the Pulsar 8K Dongle's
            ;; keyboard interface. When the dongle re-enumerates (which happens
            ;; whenever the mouse enters or exits charging mode), kanata loses
            ;; those event files and exits, dropping the HHKB keymap.
            linux-dev-names-include (
              "PFU Limited HHKB-Hybrid Keyboard"
              "PFU Limited HHKB-Hybrid"
              "PFU Limited HHKB-Hybrid Consumer Control"
            )
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
    environment.systemPackages = with pkgs;
      lib.optionals cfg.utils.enable [
        usbutils
        usbimager
      ]
      ++ lib.optionals cfg.adb.enable [
        android-tools
      ];
  };
}
