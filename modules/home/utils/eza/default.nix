{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.utils.eza;
in {
  options = {
    home.utils.eza.enable = mkEnableOption "Enables eza";
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
