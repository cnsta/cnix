{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.gaming.mangohud;
in {
  options = {
    userModules.gaming.mangohud.enable = mkEnableOption "Enables mangohud";
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
