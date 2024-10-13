{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.utils.obsidian;
in {
  options = {
    systemModules.utils.obsidian.enable = mkEnableOption "Enables obsidian";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.obsidian
    ];
  };
}
