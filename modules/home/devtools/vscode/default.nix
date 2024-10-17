{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.devtools.vscode;
in {
  options = {
    home.devtools.vscode.enable = mkEnableOption "Enables vscode";
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
    };
  };
}
