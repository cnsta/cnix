{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.floorp;
in {
  options = {
    home.programs.floorp.enable = mkEnableOption "Enables floorp browser";
  };
  config = mkIf cfg.enable {
    programs.floorp = {
      enable = true;
    };
  };
}
