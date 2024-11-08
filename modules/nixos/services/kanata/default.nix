{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.kanata;
in {
  options = {
    nixos.services.kanata.enable = mkEnableOption "Enables kanata keyboard remapping";
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