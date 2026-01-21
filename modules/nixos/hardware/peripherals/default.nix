{
  config,
  lib,
  pkgs,
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
      utils.enable = mkEnableOption "Miscellaneous utility packages";
    };
  };
  config = {
    hardware = mkIf cfg.logitech.enable {
      logitech.wireless = {
        enable = true;
        enableGraphical = true;
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
