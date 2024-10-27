{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.eza;
in {
  options = {
    home.programs.eza.enable = mkEnableOption "Enables eza";
  };
  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      git = true;
      enableZshIntegration = false;
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--icons"
      ];
    };
  };
}
