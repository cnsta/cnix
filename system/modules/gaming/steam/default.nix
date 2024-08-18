{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.gaming.steam;
in {
  options = {
    modules.gaming.steam.enable = mkEnableOption "Enables steam";
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
