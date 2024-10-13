{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.gaming.steam;
in {
  options = {
    systemModules.gaming.steam.enable = mkEnableOption "Enables steam";
  };
  config = mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
    };
  };
}
