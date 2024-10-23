{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.network.mullvad;
in {
  options = {
    nixos.services.network.mullvad.enable = mkEnableOption "Enables mullvad";
  };
  config = mkIf cfg.enable {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}
