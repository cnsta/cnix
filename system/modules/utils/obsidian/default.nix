{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.obsidian;
in {
  options = {
    modules.utils.obsidian.enable = mkEnableOption "Enables obsidian";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.obsidian
    ];
  };
}
