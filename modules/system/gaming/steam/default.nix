{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.gaming.steam;
in {
  options = {
    system.gaming.steam.enable = mkEnableOption "Enables steam";
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
