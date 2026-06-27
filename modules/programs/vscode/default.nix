{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.vscode;
in {
  options = {
    cnix.programs.vscode.enable = mkEnableOption "Enables vscode";
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
  };
}
