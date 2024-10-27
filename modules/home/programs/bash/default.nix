{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.bash;
in {
  options = {
    home.programs.bash.enable = mkEnableOption "Enables bash";
  };
  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
    };
  };
}
