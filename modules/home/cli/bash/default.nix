{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.cli.bash;
in {
  options = {
    home.cli.bash.enable = mkEnableOption "Enables bash";
  };
  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
    };
  };
}
