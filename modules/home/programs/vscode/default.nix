{
  config,
  lib,
  pkgs,
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
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        sainnhe.gruvbox-material
        vscodevim.vim
        rust-lang.rust-analyzer
        kamadorueda.alejandra
        arrterian.nix-env-selector
      ];
    };
  };
}
