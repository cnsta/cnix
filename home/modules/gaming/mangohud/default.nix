{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.gaming.mangohud;
in {
  options = {
    modules.gaming.mangohud.enable = mkEnableOption "Enables mangohud";
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
