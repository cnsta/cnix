{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.utils.eza;
in {
  options = {
    userModules.utils.eza.enable = mkEnableOption "Enables eza";
  };
  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      icons = true;
      git = true;
      enableZshIntegration = false;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };
}
