{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.gaming.steam;
in {
  options = {
    nixos.gaming.steam.enable = mkEnableOption "Enables steam";
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
