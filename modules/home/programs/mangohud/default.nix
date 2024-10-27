{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.mangohud;
in {
  options = {
    home.programs.mangohud.enable = mkEnableOption "Enables mangohud";
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
