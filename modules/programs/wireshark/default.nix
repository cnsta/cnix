{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.wireshark;
in
{
  options.cnix.programs.wireshark.enable = mkEnableOption "Enables wireshark";

  config = mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      usbmon.enable = true;
      dumpcap.enable = true;
    };
  };
}
