{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) int str;
  cfg = config.nixos.hardware.peripherals;
in
{
  imports = [
    inputs.pulsar-x2.nixosModules.default
  ];
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
        service = {
          enable = mkEnableOption ''
            Pulsar X2 systemd user service.

            Runs `pulsar-x2` (tray mode) as a systemd user service that starts
            automatically with your graphical session. The tray icon gives access
            to battery status and can launch the settings panel via your terminal.

            Requires `hardware.pulsar-x2.enable = true`.
          '';

          threshold = mkOption {
            type = int;
            default = 10;
            description = "Battery percentage threshold for low-battery desktop notifications.";
          };

          interval = mkOption {
            type = int;
            default = 60;
            description = "Battery check interval in seconds.";
          };

          terminal = mkOption {
            type = str;
            default = "";
            example = "foot";
            description = ''
              Terminal emulator to use when opening the settings panel from the tray icon.

              When set, this takes priority over $TERMINAL and the built-in fallback
              list (kitty, foot, alacritty, wezterm, ghostty, konsole, gnome-terminal, xterm).

              The service sets TERMINAL in its environment so the tray process can
              pick it up when launching `pulsar-x2 --options`.
            '';
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
      pulsar-x2 = mkIf cfg.pulsar-x2.enable {
        enable = true;
        service = mkIf cfg.pulsar-x2.service.enable {
          enable = true;
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
