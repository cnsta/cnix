{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.network.mullvad;
in {
  options = {
    systemModules.sysd.network.mullvad.enable = mkEnableOption "Enables mullvad";
  };
  config = mkIf cfg.enable {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}
