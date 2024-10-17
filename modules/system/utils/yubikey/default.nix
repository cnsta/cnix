{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.utils.yubikey;
in {
  options = {
    system.utils.yubikey.enable = mkEnableOption "Enables yubikey utilities";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.yubioath-flutter
      pkgs.yubikey-manager
      pkgs.yubikey-personalization
      pkgs.yubikey-personalization-gui
      pkgs.pcsc-tools
    ];
  };
}
