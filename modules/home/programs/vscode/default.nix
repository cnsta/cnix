{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.vscode;
in {
  options = {
    home.programs.vscode.enable = mkEnableOption "Enables vscode";
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
    };
  };
}
