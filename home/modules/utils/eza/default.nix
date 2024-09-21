{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.eza;
in {
  options = {
    modules.utils.eza.enable = mkEnableOption "Enables eza";
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
