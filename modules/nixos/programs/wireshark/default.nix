{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.wireshark;
in
{
  options = {
    nixos.programs.wireshark.enable = mkEnableOption "Enables wireshark";
  };
  config = mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      usbmon.enable = true;
      dumpcap.enable = true;
    };
  };
}
