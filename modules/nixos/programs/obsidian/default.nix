{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.obsidian;
in {
  options = {
    nixos.programs.obsidian.enable = mkEnableOption "Enables obsidian";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.obsidian
    ];
  };
}
