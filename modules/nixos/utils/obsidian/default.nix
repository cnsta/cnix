{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.utils.obsidian;
in {
  options = {
    nixos.utils.obsidian.enable = mkEnableOption "Enables obsidian";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.obsidian
    ];
  };
}
