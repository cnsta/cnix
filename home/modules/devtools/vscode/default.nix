{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.devtools.vscode;
in {
  options = {
    userModules.devtools.vscode.enable = mkEnableOption "Enables vscode";
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
    };
  };
}
