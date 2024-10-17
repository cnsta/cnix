{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.gaming.mangohud;
in {
  options = {
    home.gaming.mangohud.enable = mkEnableOption "Enables mangohud";
  };
  config = mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      settings = {
        full = true;
      };
    };
  };
}
