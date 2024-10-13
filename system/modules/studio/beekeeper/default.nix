{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.studio.beekeeper;
in {
  options = {
    systemModules.studio.beekeeper.enable = mkEnableOption "Enables Beekeeper Studio";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      beekeeper-studio
    ];
  };
}
