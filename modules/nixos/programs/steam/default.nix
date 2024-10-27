{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.steam;
in {
  options = {
    nixos.programs.steam.enable = mkEnableOption "Enables steam";
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
