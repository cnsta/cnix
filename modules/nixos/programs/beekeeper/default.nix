{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.beekeeper;
in {
  options = {
    nixos.programs.beekeeper.enable = mkEnableOption "Enables Beekeeper Studio";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      beekeeper-studio
    ];
  };
}
