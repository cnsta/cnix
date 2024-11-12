{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.yubikey;
in {
  options = {
    nixos.programs.yubikey.enable = mkEnableOption "Enables yubikey utilities";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      # pkgs.yubioath-flutter
      # pkgs.yubikey-manager
      pkgs.yubikey-personalization
      pkgs.yubikey-personalization-gui
      pkgs.yubikey-touch-detector
      # pkgs.pcsc-tools
    ];
  };
}
