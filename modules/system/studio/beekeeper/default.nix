{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.studio.beekeeper;
in {
  options = {
    system.studio.beekeeper.enable = mkEnableOption "Enables Beekeeper Studio";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      beekeeper-studio
    ];
  };
}
