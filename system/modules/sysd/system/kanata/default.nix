{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.system.kanata;
in {
  options = {
    systemModules.sysd.system.kanata.enable = mkEnableOption "Enables kanata keyboard remapping";
  };
  config = mkIf cfg.enable {
    services.kanata = {
      enable = true;
      package = pkgs.kanata-with-cmd;
      keyboards.hhkbse = {
        devices = ["/dev/input/by-id/usb-PFU_Limited_HHKB-Hybrid-event-kbd"];
        config = builtins.readFile (./. + "/hhkbse.kbd");
      };
    };
  };
}
