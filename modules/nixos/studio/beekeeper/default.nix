{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.studio.beekeeper;
in {
  options = {
    nixos.studio.beekeeper.enable = mkEnableOption "Enables Beekeeper Studio";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      beekeeper-studio
    ];
  };
}
