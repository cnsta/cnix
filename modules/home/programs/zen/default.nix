{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.zen;
in {
  options = {
    home.programs.zen.enable = mkEnableOption "Enables zen browser";
  };
  config = mkIf cfg.enable {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.system}.default
    ];
  };
}
