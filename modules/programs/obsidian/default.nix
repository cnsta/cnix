{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.obsidian;
in
{
  options = {
    cnix.programs.obsidian.enable = mkEnableOption "Enables obsidian";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.obsidian
    ];
  };
}
